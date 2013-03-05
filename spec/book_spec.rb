# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Rusk::Book do

  describe ".open" do
    context "without block" do
      it { expect { Rusk::Book.open("#{dir}/general_datas.ods") }.to_not raise_error }
    end

    context "with block" do
      it { expect {
          Rusk::Book.open("#{dir}/general_datas.ods") do |book|
            book[0]
          end
        }.to_not raise_error
      }

      it "should be able to use block parameter" do
        name = nil
        Rusk::Book.open("#{dir}/general_datas.ods") do |book|
          name = book[0].name
        end
        name.should_not be_nil
      end

    end

  end

  describe "#[]" do
    before do
      @book = Rusk::Book.open("#{dir}/general_datas.ods")
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

  describe "#save" do
    before do
      @book = Rusk::Book.open(create_tmp)
    end

    after do
      remove_tmp
    end

    it { expect { @book.save }.to_not raise_error }

  end

end
