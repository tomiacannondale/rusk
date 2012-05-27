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

  shared_context "goblin::cell when boolean(true)" do
    before do
      @cell = Goblin::Cell.new(@cells[14][1])
    end
  end

  shared_context "goblin::cell when boolean(false)" do
    before do
      @cell = Goblin::Cell.new(@cells[14][2])
    end
  end

  shared_context "goblin::cell when currency" do
    before do
      @cell = Goblin::Cell.new(@cells[15][1])
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

  shared_context "goblin::cell when enter date of time cell" do
    before do
      @cell = Goblin::Cell.new(@cells[13][1])
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

  shared_context "goblin::cell when percentage cell" do
    before do
      @cell = Goblin::Cell.new(@cells[12][1])
    end
  end

  describe "#value_type" do
    context "when enter boolean" do
      include_context "goblin::cell when boolean(true)"
      it { @cell.value_type.should eq "boolean" }
    end

    context "when enter currency" do
      include_context "goblin::cell when currency"
      it { @cell.value_type.should eq "currency" }
    end

    context "when string cell" do
      include_context "goblin::cell when string cell"
      it { @cell.value_type.should eq "string" }
    end

    context "when date cell" do
      include_context "goblin::cell when date cell"
      it { @cell.value_type.should eq "date" }
    end

    context "when enter date of time cell" do
      include_context "goblin::cell when enter date of time cell"
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

    context "when percentage cell" do
      include_context "goblin::cell when percentage cell"
      it { @cell.value_type.should eq "percentage" }
    end

  end

  describe "#value" do
    context "when boolean cell(true)" do
      include_context "goblin::cell when boolean(true)"
      it { @cell.value.should be_true }
    end

    context "when boolean cell(false)" do
      include_context "goblin::cell when boolean(false)"
      it { @cell.value.should be_false }
    end

    context "when currency cell" do
      include_context "goblin::cell when currency"
      it { @cell.value.should eq 10.0 }
    end

    context "when string cell" do
      include_context "goblin::cell when string cell"
      it { @cell.value.should eq "mruby" }
    end

    context "when date cell" do
      include_context "goblin::cell when date cell"
      it { @cell.value.should eq Date.new(2012,4,29) }
    end

    context "when enter date of time cell" do
      include_context "goblin::cell when enter date of time cell"
      it { @cell.value.should eq DateTime.new(2012,5,26,18,17) }
    end

    context "when time cell(not datetime)" do
      include_context "goblin::cell when time cell"
      it { @cell.value.should eq "16:50" }
    end

    context "when float cell" do
      include_context "goblin::cell when float cell"
      it { @cell.value.should eq 7000.0 }
    end

    context "when percentage cell" do
      include_context "goblin::cell when percentage cell"
      it { @cell.value.should eq 0.1 }
    end

  end
end
