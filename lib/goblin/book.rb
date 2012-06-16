# -*- coding: utf-8 -*-
require 'zip/zip'

module Goblin
  class Book
    attr_reader :sheets

    def initialize(file)
      @file = file
      Zip::ZipFile.open(@file) do |files|
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

    def save
      Zip::ZipFile.open(@file) do |files|
        files.get_output_stream("content.xml") { |f| f.puts @content }
      end
    end

    def self.open(file)
      new(file)
    end

  end
end
