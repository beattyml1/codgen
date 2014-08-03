#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative  'codgen_engine'
require_relative 'command_line_arguments'
require_relative 'logger'
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
  if args.json_config == nil
    json_data_text = get_file_contents(args.json_data_filename)
    json_data = JSON.parse(json_data_text)

    json_map = nil
    if args.json_map_filename
      json_map_text = get_file_contents(args.json_map_filename)
      json_map = JSON.parse(json_map_text)
    end

    template_file = File.open(args.template_filename)
    output = CodgenEngine.run_single(json_data, template_file, json_map)
    template_file.close
  else
    json_config_text = get_file_contents(args.json_config)
    json_config = JSON.parse(json_config_text)
    output = CodgenEngine.run(json_config)
  end

  output.each do |file|
    write_file_contents(file.path, file.text)
  end
end

main(CommandLineArguments.new(ARGV))