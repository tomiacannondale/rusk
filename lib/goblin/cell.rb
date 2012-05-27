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
        if @content["date-value"] =~ /^\d{4}-\d{2}-\d{2}$/
          Date.strptime(@content["date-value"], "%Y-%m-%d")
        else
          DateTime.strptime(@content["date-value"], "%Y-%m-%dT%H:%M:%S")
        end
      when "float", "currency", "percentage"
        @content["value"].to_f
      when "boolean"
        @content["boolean-value"] == 'true'
      else
        @content.xpath("text:p").text
      end
    end

    def value_type
      @content["value-type"]
    end

  end
end
