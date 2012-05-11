# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Goblin::Sheet do
  before do
    content = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml"))
    @sheet = Goblin::Sheet.new(content.xpath("//table:table")[0])
  end

  describe "#name" do
    it { @sheet.name.should eq "Sheet1" }
  end

end
