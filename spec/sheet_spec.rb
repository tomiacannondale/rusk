# -*- coding: utf-8 -*-
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Rusk::Sheet do
  before do
    @content = Nokogiri::XML(File.read("#{dir}/general_datas_content.xml"))
  end

  shared_context "read Sheet1" do
    before do
      @sheet = Rusk::Sheet.new(@content.xpath("//table:table")[0])
      @cells = [
        ["string", "mruby", ""],
        ["date", Date.new(2012,04,29), ""],
        ["time", "16:50", ""],
        ["float", 7000.0, ""],
        ["merged_cell", "", "after merged column"],
        ["merged_row cell", "merged first row cell", ""],
        ["", "merged second row cell", ""],
        ["after merged row cell", "", ""],
        ["", "", ""],
        ["after blank row", "", ""],
        ["", "after blank column", ""],
        ["hide the cell next to", "hidden cell", ""],
        ["percentage", 0.1, ""],
        ["enter date of time", DateTime.new(2012,5,26,18,17), ""],
        ["boolean", true, false],
        ["currency", 10.0, ""]
      ]
    end
  end

  shared_context "read rows-repeated" do
    before do
      @sheet = Rusk::Sheet.new(@content.xpath("//table:table")[1])
      @cells = [
        ["title1", "title2"],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""],
        ["", ""]
      ]
    end
  end

  shared_context "read file created from excel 2010" do
    before do
      content = Nokogiri::XML(File.read("#{dir}/created_from_excel2010_content.xml"))
      @sheet = Rusk::Sheet.new(content.xpath("//table:table")[0])
      @cells = [["created"], ["by"], ["excel"], [2010.0]]
    end
  end

  shared_context "read repeated" do
    before do
      content = Nokogiri::XML(File.read("#{dir}/repeated_content.xml"))
      @sheet = Rusk::Sheet.new(content.xpath("//table:table")[0])
    end
  end

  describe "#name" do
    include_context "read Sheet1"
    it { @sheet.name.should eq "Sheet1" }
  end

  describe "#[]" do
    context "read Sheet1(merged, columns-repeated, various data type)" do
      include_context "read Sheet1"
      context "with exist cell index" do
        it { @sheet[2, 1].should be_kind_of Rusk::Cell }
        it { @sheet[0, 0].value.should eq "string" }
        it { @sheet[0, 1].value.should eq "mruby" }
        it { @sheet[1, 1].value.should eq Date.new(2012,4,29) }
        it { @sheet[4, 2].value.should eq 'after merged column' }
        it { @sheet[5, 1].value.should eq 'merged first row cell' }
        it { @sheet[6, 1].value.should eq 'merged second row cell' }
        it { @sheet[8, 0].value.should eq "" }
        it { @sheet[8, 1].value.should eq "" }
        it { @sheet[11, 0].value.should eq 'hide the cell next to' }
        it { @sheet[11, 1].value.should eq 'hidden cell' }
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

    context "read rows-repeated" do
      include_context "read rows-repeated"
      it { @sheet.map(&:value).should have(24).items }
      it { @sheet.map(&:value).should eq @cells.flatten }
    end

    context "read created_from_excel2010" do
      include_context "read file created from excel 2010"
      it { @sheet[0, 0].value.should eq "created" }
      it { @sheet[1, 0].value.should eq "by" }
      it { @sheet.map(&:value).should eq @cells.flatten }
    end

  end

  describe "#each" do
    include_context "read Sheet1"
    it "access order by row and column" do
      cells = @cells.flatten
      index = 0
      @sheet.each do |cell|
        cell.value.should eq cells[index]
        index += 1
      end

      index.should eq cells.size
    end

    context "without block" do
      it { @sheet.each.should be_kind_of Enumerator }
    end
  end

  describe "#each_row" do
    shared_examples "Sheet#each_row access order by first row" do
      it "access order by first row" do
        index = 0
        @sheet.each_row do |rows|
          rows.map(&:value).should eq @cells[index]
          index += 1
        end

        index.should eq @cells.size
      end
    end

    context "read Sheet1 of general_datas.ods" do
      include_context "read Sheet1"
      it_behaves_like "Sheet#each_row access order by first row"
    end

    context "read file created from excel" do
      include_context "read file created from excel 2010"
      it_behaves_like "Sheet#each_row access order by first row"

      context "once call Sheet#each_row" do
        before do
          @sheet.each_row do |cell|
          end
        end

        it_behaves_like "Sheet#each_row access order by first row"
      end
    end

    context "without block" do
      include_context "read Sheet1"
      it { @sheet.each_row.should be_kind_of Enumerator }
    end
  end

  describe "#each_column" do
    include_context "read Sheet1"
    it "access order by first column" do
      index = 0
      cells = @cells.transpose
      @sheet.each_column do |columns|
        columns.map(&:value).should eq cells[index]
        index += 1
      end
      index.should eq cells.size
    end

    context "without block" do
      it { @sheet.each_column.should be_kind_of Enumerator }
    end
  end

  describe "modify ods file" do
    before do
      @tmp_file = create_tmp
    end

    after do
      remove_tmp
    end

    describe "#name=" do
      context "change sheet name of sheet2 to 'changed'" do
        before do
          Rusk::Book.open(@tmp_file) do |book|
            book[1].name = "changed"
            book.save
          end
          @book = Rusk::Book.open(@tmp_file)
        end

        it { @book[1].name.should eq "changed" }
      end
    end

    context "read rows-repeated" do
      before do
        Rusk::Book.open(@tmp_file) do |book|
          sheet = book[1]
          sheet[1, 1].value = "modified 1,1"
          sheet[2, 1].value = "modified 2,1"
          sheet[3, 0].value = "modified 3,0"
          sheet[3, 1].value = "modified 3,1"
          sheet[11, 1].value = "modified 11,1"
          sheet[5, 1].value = "modified 5,1"
          book.save
        end
        @sheet = Rusk::Book.open(@tmp_file)[1]
      end

      it { @sheet[1,0].value.should eq "" }
      it { @sheet[1,1].value.should eq "modified 1,1" }
      it { @sheet[2,0].value.should eq "" }
      it { @sheet[2,1].value.should eq "modified 2,1" }
      it { @sheet[3,0].value.should eq "modified 3,0" }
      it { @sheet[3,1].value.should eq "modified 3,1" }
      it { @sheet[4,0].value.should eq "" }
      it { @sheet[4,1].value.should eq "" }
      it { @sheet[5,0].value.should eq "" }
      it { @sheet[5,1].value.should eq "modified 5,1" }
      it { @sheet[6,0].value.should eq "" }
      it { @sheet[6,1].value.should eq "" }
      it { @sheet[7,0].value.should eq "" }
      it { @sheet[7,1].value.should eq "" }
      it { @sheet[8,0].value.should eq "" }
      it { @sheet[8,1].value.should eq "" }
      it { @sheet[9,0].value.should eq "" }
      it { @sheet[9,1].value.should eq "" }
      it { @sheet[10,0].value.should eq "" }
      it { @sheet[10,1].value.should eq "" }
      it { @sheet[11,0].value.should eq "" }
      it { @sheet[11,1].value.should eq "modified 11,1" }

    end
  end

  describe "#row_size" do
    context "read general_datas" do
      include_context "read Sheet1"
      it { @sheet.row_size.should eq 16 }
    end

    context "read file created from excel 2010" do
      include_context "read file created from excel 2010"
      it { @sheet.row_size.should eq 4  }
    end

    context "read repeated.ods" do
      include_context "read repeated"
      it { @sheet.row_size.should eq 8 }
    end
  end

  describe "#colum_size" do
    context "read general_datas" do
      include_context "read Sheet1"
      it { @sheet.column_size.should eq 3 }
    end

    context "read file created from excel 2010" do
      include_context "read file created from excel 2010"
      it { @sheet.column_size.should eq 1 }
    end

    context "read repeated.ods" do
      include_context "read repeated"
      it { @sheet.column_size.should eq 4 }
    end
  end

end
