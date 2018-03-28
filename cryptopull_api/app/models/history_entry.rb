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
end