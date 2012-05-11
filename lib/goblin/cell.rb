# -*- coding: utf-8 -*-
require 'date'

module Goblin
  class Cell
    def initialize(content)
      @content = content
    end

    def value
      case value_type
      when "date"
        Date.strptime(@content["date-value"], "%Y-%m-%d")
      when "float"
        @content["value"].to_f
      else
        @content.xpath("text:p").text
      end
    end

    def value_type
      @content["value-type"]
    end

  end
end
