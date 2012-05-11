# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Goblin::Book do

  describe ".open" do
    it { expect { Goblin::Book.open("#{dir}/general_datas.ods") }.to_not raise_error }
  end

end
