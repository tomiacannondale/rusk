# -*- coding: utf-8 -*-

module Rusk
  class Sheet
    include Enumerable

    attr_reader :row_size
    attr_reader :rows

    def initialize(content)
      @content = content
      @cells = []
      @rows = []
      count = 0
      @content.xpath('.//table:table-row').select do |row|
        repeated = row["table:number-rows-repeated"].to_i || 0
        @rows << Rusk::Row.new(count, count + repeated, row)
        count += repeated + 1
      end
      @row_size = count
    end

    def name
      @content["table:name"]
    end

    def name= name
      @content["table:name"] = name
    end

    def [](row_number)
      rows.each do |r|
        if r.from >= row_number && row_number <= r.to
          return r
        end
      end
      return nil
    end

    def each(&block)
      return Enumerator.new(self) unless block
      (@row_size - 1).times do |i|
        yield self[i]
      end
    end
  end
end
