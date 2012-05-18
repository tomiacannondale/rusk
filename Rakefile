#!/usr/bin/env rake
require "bundler/gem_tasks"
require 'zip/zip'
require 'nokogiri'

desc "Convert all spec/data/*.ods files to spec/data/*_content.xml files"
task :convert_ods do
  dir = File.expand_path('spec/data', File.dirname(__FILE__))
  Dir.glob("#{dir}/*.ods").each do |file|
    output_file = File.join(dir, File.basename(file, '.ods') + '_content.xml')
    File.open(output_file, 'w') do |f|
      Zip::ZipFile.open(file) do |zip_files|
        f.puts Nokogiri::XML(zip_files.read("content.xml"))
      end
    end
  end
end
