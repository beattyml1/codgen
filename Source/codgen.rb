#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative 'codgen_core'
require_relative 'command_line_arguments'
require_relative 'utilities/logger'
require 'fileutils'


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
    output = CodgenEngine.run(json_config)
    output.each do |file|
      write_file_contents(file.path, file.text)
    end
  end
end

main(CommandLineArguments.new(ARGV))