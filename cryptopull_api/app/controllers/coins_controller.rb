require "#{Rails.root}/lib/coinmarket"

class CoinsController < ApplicationController 
    def index
        result = HistoryEntry.get_coin_stats.map do |c|
            c.merge({
                price: c['price'].to_f,
                price_btc: c['price_btc'].to_f,
                supply: c['supply'].to_f,
                change: (c['change'].to_f - 1) * 100,
                price_avg: c['price_avg'].to_f
            })
        end
        json_response result
    end
end