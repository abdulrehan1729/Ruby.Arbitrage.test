class BinanceController < ApplicationController

  layout false

  def index
    HitbtcApiJob.perform_later
    BinanceApiJob.perform_later
    HitbtcApiWorker.perform_async
    BinanceApiWorker.perform_async  
    while true 
      sleep 2
      arbitrage
    end
  end

  def arbitrage
    $redis.hgetall('binanceSocket').each do|key,bin_val|
      hitkey = $redis.hget('hitbtcSocket',key)
      if hitkey != nil
        
        #HitBtc variables
        hitkey = JSON.parse(hitkey)
        hitLastPrice = hitkey['last'].to_f
        hitAskPrice = hitkey['ask'].to_f
        hitBidPrice = hitkey['bid'].to_f

        #Binance variables
        bin_val = JSON.parse(bin_val.gsub('=>',':'))
        binLatestPrice = bin_val['c'].to_f
        binAskPrice = bin_val['a'].to_f
        binBidPrice = bin_val['b'].to_f
        
        if binLatestPrice > 0 && hitLastPrice > 0
          if hitLastPrice > binLatestPrice
            arb_per = ((hitAskPrice-binBidPrice)*100/hitAskPrice).round(4)
            puts "HitBTC : #{key} : #{arb_per}%"
          else
            arb_per = ((binAskPrice-hitBidPrice)*100/binAskPrice).round(4)
            puts "Binance : #{key} : #{arb_per}%"
          end
        end
      end
    end
  end
end
