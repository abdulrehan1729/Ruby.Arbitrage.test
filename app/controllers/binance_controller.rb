class BinanceController < ApplicationController

    layout false

    def index
        puts $redis.hgetall('binance')
        # puts $redis.hgetall('hitbtc').keys        
    end

#Binance API 
    def bin_market
        res = RestClient.get('https://api.binance.com/api/v1/ticker/24hr')
        res = JSON.parse(res.body)
        res.each do |val|
            $redis.hset("binance",val['symbol'],val.to_json.to_s)
        end
    end

    EM.run {
     ws = Faye::WebSocket::Client.new("wss://stream.binance.com:9443/ws/bnbbtc@ticker")

  ws.on :open do |event|
    p [:open]
    ws.send('Hello, world!')
  end

  ws.on :message do |event|
    p [:message, event.data]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}

#HitBTC API
    def hit_market
        responce = RestClient.get('https://api.hitbtc.com/api/2/public/ticker')
        responce = JSON.parse(responce.body)
        return responce.map do |val|
          $redis.hset("hitbtc",val['symbol'],val.to_json.to_s) 
        end
        
    end
end
