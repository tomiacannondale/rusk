# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Goblin::Book do

  describe ".open" do
    it { expect { Goblin::Book.open("#{dir}/general_datas.ods") }.to_not raise_error }
  end

  describe "#[]" do
    before do
      @book = Goblin::Book.open("#{dir}/general_datas.ods")
    end

    context "with numeric" do
      it { @book[0].name.should eq "Sheet1" }
    end

    context "with sheet name" do
      it { @book["Sheet1"].name.should eq "Sheet1" }
    end

    context "with not exist sheet name" do
      it { @book["not exist"].should be_nil }
    end

    context "with not exist index" do
      it { @book[100000].should be_nil }
    end

  end

end
