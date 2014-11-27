#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative '../lib/codgen'
require_relative '../lib/codgen/logger'
require 'fileutils'

class CommandLineArguments
  def initialize(arguments)
    if arguments.count < 1
      puts 'Help file placeholder'
      exit 0
    end

    if arguments.count == 1
      @json_config = arguments[0]
    end
  end

  attr_reader :json_config
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
  if args.json_config != nil
    json_config_text = get_file_contents(args.json_config)
    json_config = JSON.parse(json_config_text)
    output = Codgen.run(json_config)
    output.each do |path, text|
      write_file_contents(path, text)
    end
  end
end

main(CommandLineArguments.new(ARGV))