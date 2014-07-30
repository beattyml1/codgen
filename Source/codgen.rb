#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative  'codgen_engine'
require_relative 'command_line_arguments'
require_relative 'logger'


def get_file_contents(filepath)
  if File.exist?(filepath)
    File.read(filepath)
  else
    Logger.error('Could not find file "'+filepath+'"')
  end
end


def write_file_contents(filepath, content)
  File.write(filepath, content)
end


def main(args)
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
  write_file_contents(args.output_filename, output)
  # write_file_contents('temp.json', JSON.pretty_unparse(json_data)) # frequently used debug code
end

main(CommandLineArguments.new(ARGV))