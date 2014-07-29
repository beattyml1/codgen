#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative  'codgen_engine'


def get_args
  if ARGV.count < 3
    puts 'Invalid argument count, arguments should be like: data.json template.cs ouput.json [optional-map.json]'
    exit 1
  end

  return_obj = OpenStruct.new
  return_obj.json_data_filename = ARGV[0]
  return_obj.template_filename = ARGV[1]
  return_obj.output_filename = ARGV[2]

  if ARGV.count == 4
    return_obj.json_map_filename = ARGV[3]
  else
    return_obj.json_map_filename = nil
  end

  return_obj
end


def get_file_contents(filepath)
  if File.exist?(filepath)
    File.read(filepath)
  else
    puts 'Could not find file "'+filepath+'"'
    exit 1
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

main(get_args)