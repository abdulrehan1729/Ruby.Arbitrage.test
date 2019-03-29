class HitbtcApiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    responce = HTTParty.get('https://api.hitbtc.com/api/2/public/ticker')
    responce = JSON.parse(responce.body)
    responce.map do |val|
      $redis.hset("hitbtc",val['symbol'],val.to_json.to_s) 
    end
  end
end
