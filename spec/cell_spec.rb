# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Goblin::Cell do
  before do
    @general_datas_content = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml"))
    @cells = []
    @general_datas_content.xpath('.//table:table-row').each do |i|
      @cells << i.xpath(".//table:table-cell|.//table:covered-table-cell")
    end
  end

  shared_context "goblin::cell when string cell" do
    before do
      @cell = Goblin::Cell.new(@cells[0][1])
    end
  end

  shared_context "goblin::cell when date cell" do
    before do
      @cell = Goblin::Cell.new(@cells[1][1])
    end
  end

  shared_context "goblin::cell when time cell" do
    before do
      @cell = Goblin::Cell.new(@cells[2][1])
    end
  end

  shared_context "goblin::cell when float cell" do
    before do
      @cell = Goblin::Cell.new(@cells[3][1])
    end
  end

  describe "#value_type" do
    context "when string cell" do
      include_context "goblin::cell when string cell"
      it { @cell.value_type.should eq "string" }
    end

    context "when date cell" do
      include_context "goblin::cell when date cell"
      it { @cell.value_type.should eq "date" }
    end

    context "when time cell(not datetime)" do
      include_context "goblin::cell when time cell"
      it { @cell.value_type.should eq "time" }
    end

    context "when float cell" do
      include_context "goblin::cell when float cell"
      it { @cell.value_type.should eq "float" }
    end
  end

  describe "#value" do
    context "when string cell" do
      include_context "goblin::cell when string cell"
      it { @cell.value.should eq "mruby" }
    end

    context "when date cell" do
      include_context "goblin::cell when date cell"
      it { @cell.value.should eq Date.new(2012,4,29) }
    end

    context "when time cell(not datetime)" do
      include_context "goblin::cell when time cell"
      it { @cell.value.should eq "16:50" }
    end

    context "when float cell" do
      include_context "goblin::cell when float cell"
      it { @cell.value.should eq 7000.0 }
    end

  end
end
