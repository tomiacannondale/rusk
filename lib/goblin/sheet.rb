# -*- coding: utf-8 -*-

module Goblin
  class Sheet
    def initialize(content)
      @content = content
    end

    def name
      @content["name"]
    end
  end
end
