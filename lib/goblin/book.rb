# -*- coding: utf-8 -*-
require 'zip/zip'

module Goblin
  class Book
    def initialize(file)
      Zip::ZipFile.open(file) do |files|
        @content = Nokogiri::XML(files.read("content.xml"))
      end
    end

    def self.open(file)
      new(file)
    end

  end
end
