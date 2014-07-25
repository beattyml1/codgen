#!/usr/bin/env ruby
require 'ostruct'
require 'json'
require_relative 'template'
require_relative './auto_style'
require_relative './mapping'


def get_args
  if ARGV.count < 3
    puts 'Invalid arguement count, arguments should be like: data.json template.cs ouput.json [optional-map.json]'
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

  return return_obj
end


def get_file_contents(filepath)
  return File.read(filepath)
end


def write_file_contents(filepath, content)
  File.write(filepath, content)
end


def main(args)
  json_data_text = get_file_contents(args.json_data_filename)
  template_text = get_file_contents(args.template_filename)
  json_data = JSON.parse(json_data_text)

  if args.json_map_filename
    json_map_text = get_file_contents(args.json_map_filename)
    json_map = JSON.parse(json_map_text)

    Mapping.map_object(json_data, json_map)
  end

  AutoStyle.style_casing(json_data)

  json_object_chain = [ json_data ]
  root_template = Template.new(nil, 'root')
  root_template.parse(template_text)
  output = root_template.fill(json_object_chain)
  write_file_contents(args.output_filename, output)
end

main(get_args())






