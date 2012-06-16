# -*- coding: utf-8 -*-
require 'rspec'
require File.expand_path('../lib/goblin', File.dirname(__FILE__))
require 'pry'
require 'fileutils'

module Goblin::SpecHelpers
  def dir
    File.expand_path("data", File.dirname(__FILE__))
  end

  def create_tmp(file = "general_datas.ods")
    tmp_book = "#{dir}/tmp_#{file}"
    FileUtils.cp "#{dir}/#{file}", tmp_book
    tmp_book
  end

  def remove_tmp(file = "general_datas.ods")
    FileUtils.rm "#{dir}/tmp_#{file}"
  end

end

RSpec.configure do |config|
  config.include Goblin::SpecHelpers
end
