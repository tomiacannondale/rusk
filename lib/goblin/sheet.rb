# -*- coding: utf-8 -*-

module Goblin
  class Sheet
    include Enumerable

    def initialize(content)
      @content = content
      @cells = []
      @content.xpath('.//table:table-row').each do |row_range|
        @cells << row_range.xpath(".//table:table-cell|.//table:covered-table-cell")
      end
    end

    def name
      @content["name"]
    end

    def [](row, column)
      return nil if row > @cells.size || column > @cells[0].size
      Goblin::Cell.new(@cells[row][column])
    end

    def each
      @cells.each do |rows|
        rows.each do |cell|
          yield Goblin::Cell.new(cell)
        end
      end
    end

    def each_row
      @cells.each do |rows|
        yield rows.map{ |i| Goblin::Cell.new(i) }
      end
    end

  end
end
