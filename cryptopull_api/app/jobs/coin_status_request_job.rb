require "#{Rails.root}/lib/coinmarket"

class CoinStatusRequestJob < ApplicationJob
    after_perform do |job|
        if job.arguments.first != 'forced'
            self.class.set(wait: 1.minute).perform_later
        end
    end

    def perform(arg = nil)
        byebug
        arr = CoinApi.fetch_coin_stats
        HistoryEntry.bulk_insert(arr)
    end
end