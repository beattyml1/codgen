require 'rspec'
require 'fileutils'
require_relative 'test_utils'

describe 'Application' do
  $expectation_directory = 'expected_output'
  $output_directory = 'Output'
  before :all do

    FileUtils.rm_rf($output_directory)

    puts `ruby ../../bin/codgen.rb config.json`
  end

  it 'should produce all expected files' do
    files_and_folders = Dir.glob($expectation_directory+'/**/*')
    files_and_folders.each do |expected_file_path|
      if File.file?(expected_file_path)
        output_file_path = expected_file_path.sub($expectation_directory, $output_directory)
        expect(File.exist?(output_file_path)).to be_truthy
      end
    end
  end


  files_and_folders = Dir.glob($expectation_directory+'/**/*')
  files_and_folders.each do |expected_file_path|
    if File.file?(expected_file_path)
      output_file_path = expected_file_path.sub($expectation_directory, $output_directory)
      it "should produce file: '#{output_file_path}' that is the same as '#{expected_file_path}'" do
        expect(File.exist?(output_file_path)).to be_truthy
        expect(FileUtils.cmp(output_file_path, expected_file_path)).to be_truthy
      end
    end
  end
end