class HitbtcApiWorker
  include Sidekiq::Worker

  def perform(*args)
    EM.run{
      hitSocket = Faye::WebSocket::Client.new("wss://api.hitbtc.com/api/2/ws")
      $redis.hgetall('hitbtc').each do |key,val|
 
        hitObj = {method: "subscribeTicker",params:{symbol: key},id: 123}
        hitSocket.on :open do |event|
          # p [:open]
          hitSocket.send(hitObj.to_json)
        end

        hitSocket.on :message do |event|
          data = JSON.parse(event.data)['params']
          # puts "hitBTC"
          if data != nil
            puts 'its working.....'
            $redis.hset('hitbtcSocket', data['symbol'], data.to_json.to_s)
          end
        end

        hitSocket.on :close do |event|
          p [:close, event.code, event.reason]
          hitSocket = nil
        end
      end
    }
  end
end
