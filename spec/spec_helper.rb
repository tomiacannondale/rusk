# -*- coding: utf-8 -*-
require 'rspec'
require File.expand_path('../lib/goblin', File.dirname(__FILE__))
require 'pry'
require 'fileutils'

module Goblin::SpecHelpers
  def dir
    File.expand_path("data", File.dirname(__FILE__))
  end
end

RSpec.configure do |config|
  config.include Goblin::SpecHelpers
end
