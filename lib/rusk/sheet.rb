# -*- coding: utf-8 -*-

module Rusk
  class Sheet
    include Enumerable

    def initialize(content)
      @content = content
      @cells = []
      @content.xpath('.//table:table-row').each do |row_range|
        row_cells = []
        row_range.xpath(".//table:table-cell|.//table:covered-table-cell").each do |cell|
          row_cells << Rusk::Cell.new(cell)
          (cell["table:number-columns-repeated"].to_i - 1).times do
            row_cells << Rusk::Cell.new(cell)
          end
        end
        @cells << row_cells
      end
    end

    def name
      @content["table:name"]
    end

    def name= name
      @content["table:name"] = name
    end

    def [](row, column)
      return nil if row > @cells.size || column > @cells[0].size
      @cells[row][column]
    end

    def each
      @cells.each do |rows|
        rows.each do |cell|
          yield cell
        end
      end
    end

    def each_row
      @cells.each do |rows|
        yield rows
      end
    end

    def each_column
      @cells.transpose.each do |columns|
        yield columns
      end
    end

  end
end
