class HistoryEntry < ApplicationRecord
    self.table_name = :coin_history

    def self.bulk_insert(arr)
        return if arr.to_a.empty?
        
        values_str = arr.map do |entry|
            escaped_list = entry.values.map{|entity| entity.is_a?(String) ? "\'#{entity}\'" : entity}.join(',')
            "(#{escaped_list})"
        end.join(',')

        sql = <<-SQL
            INSERT INTO #{table_name} 
            (#{columns.map(&:name).join(',')}) 
            VALUES #{values_str}
            ON CONFLICT DO NOTHING
        SQL
        
        connection.execute(sql)
    end

    def self.get_coin_stats
        sql = <<-SQL
            SELECT DISTINCT ON(id) *,
                (first_value(price) OVER day_window / last_value(price) OVER day_window) as change,
                avg(price) OVER day_window AS price_avg
            FROM (
            SELECT *
            FROM coin_history
            WHERE updated >= EXTRACT(epoch FROM (localtimestamp - interval '24 hours'))
            ) AS day_frame
            WINDOW day_window AS (
                PARTITION BY id 
                ORDER BY updated DESC
                ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
            ) 
        SQL

        connection.execute(sql)
    end
end