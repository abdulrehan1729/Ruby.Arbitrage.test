class BinanceApiWorker
  include Sidekiq::Worker

  def perform(*args)
    EM.run {
      $redis.hgetall('binance').each do |key,val|
        binanceSocket = Faye::WebSocket::Client.new("wss://stream.binance.com:9443/ws/#{key.downcase}@ticker")
        
        binanceSocket.on :message do |event|
          if event.data != nil
            puts "websocket update"     
            $redis.hset('binanceSocket', data['s'], data.to_json.to_s)
          end
        end
      
        binanceSocket.on :close do |event|
          # p [:close, event.code, event.reason]
          binanceSocket = nil
        end    
      end
    }
  end
end
