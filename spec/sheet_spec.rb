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

  describe "#[]" do
    context "with exist cell index" do
      it { @sheet[2, 1].should be_kind_of Goblin::Cell }
      it { @sheet[0, 0].value.should eq "string" }
      it { @sheet[0, 1].value.should eq "mruby" }
      it { @sheet[1, 1].value.should eq Date.new(2012,4,29) }
    end

    context "with not exist cell index" do
      context "when row is existing, column is not existing" do
        it { @sheet[0, 1000].should be_nil }
      end

      context "when row and column is not existing" do
        it { @sheet[1000, 10000].should be_nil }
      end
    end
  end

end
