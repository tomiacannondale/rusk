# -*- coding: utf-8 -*-
require 'zip/zip'

module Goblin
  class Book
    def initialize(file)
      Zip::ZipFile.open(file) do |files|
        @content = Nokogiri::XML(files.read("content.xml"))
      end
      @sheets = @content.xpath("//table:table")
    end

    def [](name_or_index)
      if name_or_index.is_a? Numeric
        sheet = @sheets[name_or_index]
      else
        sheet = @sheets.detect{ |i| i["name"] == name_or_index }
      end
      sheet && Goblin::Sheet.new(sheet)
    end

    def self.open(file)
      new(file)
    end

  end
end
