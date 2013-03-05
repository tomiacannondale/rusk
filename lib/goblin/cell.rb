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
        if @content["office:date-value"] =~ /^\d{4}-\d{2}-\d{2}$/
          Date.strptime(@content["office:date-value"], "%Y-%m-%d")
        else
          DateTime.strptime(@content["office:date-value"], "%Y-%m-%dT%H:%M:%S")
        end
      when "float", "currency", "percentage"
        @content["office:value"].to_f
      when "boolean"
        @content["office:boolean-value"] == 'true'
      else
        @content.xpath("text:p").text
      end
    end

    def value=(value)
      if value.is_a? Numeric
        @content["office:value"] = value.to_s
        @content["office:value-type"] = "float"
      elsif value.is_a? Date
        @content["office:date-value"] = value.strftime("%F")
        @content["office:value-type"] = 'date'
      else
        @content["office:value-type"] = 'string'
      end
      @content.xpath("text:p").children.first.content = value
    end

    def value_type
      @content["office:value-type"]
    end

    def to_s
      @content.xpath("text:p").text
    end

  end
end
