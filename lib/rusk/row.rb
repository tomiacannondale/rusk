module Rusk
  class Row
    include Enumerable

    attr_reader :from
    attr_reader :to

    def initialize(from, to, content)
      @from = from
      @to = to
      @content = content
      @cells = []
      @content.xpath('.//table:table-cell|.//table:covered-table-cell').each_with_index do |cell, index|
        number_repeated = cell["table:number-columns-repeated"].to_i
        break if number_repeated + index >= 1024

        @cells << Rusk::Cell.new(cell)

        if number_repeated > 1
          cell.remove_attribute("number-columns-repeated")
          (number_repeated - 1).times do
            @cells << Rusk::Cell.new(cell)
          end
        end
      end
    end

    def [](column)
      if column < @cells.size
        @cells[column]
      else
        nil
      end
    end

    def each
      @cells.each do |c|
        yield c
      end
    end

  end
end
