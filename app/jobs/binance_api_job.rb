class BinanceApiJob < ApplicationJob
  queue_as :default

  def perform(*args)
    puts 'binance'
    res = HTTParty.get('https://api.binance.com/api/v1/ticker/24hr')
    res = JSON.parse(res.body)
    res.each do |val|
      $redis.hset("binance",val['symbol'],val.to_json.to_s)
    end
  end
end
