require "http"

module CoinApi
    COIN_MARKET_BASE_URL = 'https://api.coinmarketcap.com/v1'
    TICKER_ENDPOINT = COIN_MARKET_BASE_URL + '/ticker/'
    DEFAULT_COUNT = 20

    def self.fetch_coin_stats
        response = HTTP.follow.get(TICKER_ENDPOINT, params: {limit: DEFAULT_COUNT})
        if (response.code == 200)
            JSON.parse(response.to_s).map do |coin|
               {    
                   coin_id: coin['id'],
                   updated: coin['last_updated'].to_i,
                   name: coin['name'],
                   symbol: coin['symbol'],
                   rank: coin['rank'].to_i,
                   price: coin['price_usd'].to_f,
                   price_btc: coin['price_btc'].to_f,
                   supply: coin['available_supply'].to_f
               } 
            end
        else
            []
        end
    end

    def self.dry_run
        [{
            coin_id: "bitcoin",
            updated: 1472762067,
            name: "Bitcoin",
            symbol: "BTC",
            rank: 1,
            price: 573.137,
            price_btc: 1.0,
            supply: 15844176.0
        }]
    end

end