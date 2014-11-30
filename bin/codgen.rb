#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative '../lib/codgen'
require_relative '../lib/codgen/logger'
require 'fileutils'

class CommandLineArguments
  def initialize(arguments)
    if arguments.count < 1
      @input_directory = '.'
      @json_config = 'config.json'
    end

    if arguments.count >= 1
      if arguments[0] == '--help'
        puts ''
      elsif File.directory?(arguments[0])
        @input_directory = arguments[0]
        @json_config = 'config.json'
      elsif File.extname(arguments[0]).downcase == '.json'
        @json_config = File.basename(arguments[0])
        @input_directory = File.dirname(arguments[0])
      else
        puts "Could not find directory '#{arguments[0]}', must be either a directory or a .json file"
        exit 1
      end
    end

    @output_directory = (arguments.count >= 2) ? arguments[1] : '.'
  end

  attr_reader :json_config, :input_directory, :output_directory
end

def get_file_contents(filepath)
  if File.exist?(filepath)
    File.read(filepath)
  else
    Logger.error('Could not find file "'+filepath+'"')
  end
end


def write_file_contents(filepath, content)
  dir = File.dirname(filepath)
  FileUtils.mkpath(dir) unless Dir.exists?(dir)
  File.write(filepath, content)
end


def main(args)
    original_dir = Dir.pwd
    Dir.chdir args.input_directory

    json_config_text = get_file_contents(args.json_config)
    json_config = JSON.parse(json_config_text)

    output = Codgen.run(json_config)

    output_dir = "#{original_dir}/#{args.output_directory}"

    if !Dir.exists?(output_dir)
      Dir.mkdir(output_dir)
    end

    Dir.chdir(output_dir)

    output.each do |path, text|
      write_file_contents(path, text)
    end
end

main(CommandLineArguments.new(ARGV))