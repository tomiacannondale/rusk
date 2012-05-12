# -*- coding: utf-8 -*-

module Goblin
  class Sheet
    def initialize(content)
      @content = content
    end

    def name
      @content["name"]
    end

    def [](row, column)
      row_content = @content.xpath(".//table:table-row")[row]
      return nil unless row_content
      cell_content = row_content.xpath(".//table:table-cell")[column]
      cell_content && Goblin::Cell.new(cell_content)
    end

    def each
      @content.xpath(".//table:table-row").each do |rows|
        rows.xpath(".//table:table-cell").each do |cell|
          yield Goblin::Cell.new(cell)
        end
      end
    end

  end
end
