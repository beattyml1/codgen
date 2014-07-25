#!/usr/bin/env ruby
require 'ostruct'
require 'json'

# This is not a thread safe object!
class Template
  def initialize(parent, name)
    @parent = parent
    @name = name
    @remaining_text = ''
    @templates = Hash.new
    @text = ''
  end


  def parse(remaining_text)
    @remaining_text = remaining_text

    if @remaining_text.length == 0
      return ''
    end

    loop do 
      template_tag_start_index = @remaining_text.index('<<<')

      if template_tag_start_index == nil
        @text += @remaining_text
        return ''
      end

      before_text = @remaining_text[0...template_tag_start_index]
      @text += before_text

      @remaining_text = @remaining_text[template_tag_start_index+3...@remaining_text.length]

      tag_type = get_next_word()

      template_name = get_next_word()

      template_tag_end_index = @remaining_text.index('>>>')

      @remaining_text = @remaining_text[template_tag_end_index+3, @remaining_text.length-3-template_tag_end_index]

      if tag_type == 'start'
        template = Template.new(self, template_name)
        @templates.store(template_name, template)
        @text += '{{'+template_name+'}}'
        @remaining_text = template.parse(@remaining_text)
      elsif tag_type == 'end'
        if template_name == @name
          return @remaining_text
        else
          throw "Template close tag '"+template_name+"' does not match template start tag '"+@name+"'"
        end
      else
        throw "Expected template end tag for '"+@name+"' encounterd end tag for '"+template_name+"'" 
      end
    end
  end


  def get_fill_template_list(template_name, template_array, levels)
    template_list_output = ''

    template_array.each do |template_data|
      template = @templates[template_name]
      next_level = template_data
      next_levels = Array.new(levels).insert(0, next_level)

      template_list_output += template.fill(next_levels)
    end

    template_list_output
  end



  def fill(levels)
    current_filled_template = @text

    levels[0].each do |key, value|
      if value.is_a?(Array)
        filled_templates = get_fill_template_list(key, value, levels)
        current_filled_template = get_fill_single_field(key, filled_templates , current_filled_template)
      end
    end

    levels.each do |level|
      if level.is_a?(Array)
        next
      end

      level.each do |key, value|
        if value.is_a?(String)
          current_filled_template = get_fill_single_field(key, value, current_filled_template)
        elsif !!value == value
          current_filled_template = get_fill_single_switch(key, value, current_filled_template)
        end
      end
    end

    current_filled_template
  end


  def name
    @name
  end

  def get_fill_single_field(name, value, current_filled_template)
    current_filled_template.gsub('{{'+name+'}}', value)
  end


  def get_fill_single_switch(name, value, current_filled_template)
    regex = Regexp.new('^.*##:'+name+'\?.*$') # Should match lines ending with ##:name?
    matches = current_filled_template.scan(regex)

    if value
      matches.each do |match|
        inserted_line = match.sub('##:'+name+'?', '')
        current_filled_template.sub!(match, inserted_line)
      end
    else
      matches.each do |match|
        line_start = current_filled_template.index(match)
        current_filled_template.gsub!(match, '')
        current_filled_template = current_filled_template[0...line_start-1] + current_filled_template[line_start...current_filled_template.length]
      end
    end
    current_filled_template
  end


  def get_next_word
    @remaining_text = @remaining_text.lstrip

    id = ''
    loop do
      continue = is_id_char(@remaining_text[0])

      if !continue
        break;
      end

      id += @remaining_text[0]

      if @remaining_text.length > 1
        @remaining_text = @remaining_text[1...@remaining_text.length]
      else 
        throw 'Expected end of tag or next word'
      end
    end

    @remaining_text = @remaining_text.rstrip

    return id
  end


  def is_id_char(input_string)
    first_match = input_string.index(/[a-zA-Z0-9_:]/)
    first_match == 0
  end
end


module Mapping
  def self.map_object(json_data, json_map_data)
    if json_data != nil && json_data.is_a?(Array)
      json_data.each do |item|
        map_object(item, json_map_data)
      end
      return
    end

    add_entries = Hash.new
    json_data.each do |key, value|
      if value != nil && value.is_a?(Array) || value.is_a?(Hash)
        map_object(value, json_map_data)
        next
      end

      map = json_map_data[key]
      if map != nil
        map.each do |output_key, value_map|
          if !json_data.has_key?(output_key)
            output_value = value
            value_map.each do |match_expr, map_value|
              if Regexp.new(match_expr).match(value)
                output_value = map_value
                break
              end
            end
            add_entries.store(output_key, output_value)
          end
        end
      end
    end

    add_entries.each do |key, value|
      json_data.store(key, value)
    end
  end
end


module AutoStyle
  public
    def self.style_casing(json_object)
      if json_object.is_a?(Array)
        json_object.each { |child| style_casing(child) }
      end

      add_props = Hash.new
      if json_object.is_a?(Hash)
        json_object.each do |key, value|
          if value.is_a?(Hash) || value.is_a?(Array)
            style_casing(value)
            next
          end

          if key.index(' ') || key.index('%')
            add_props.store(key, value)
          end
        end
      end

      add_props.each do |key, value|
        add_property_group(json_object, key, value, AutoStyle.method(:to_camel), '%camelCase')
        add_property_group(json_object, key, value, AutoStyle.method(:to_cap_camel), '%CapCamel')
        add_property_group(json_object, key, value, AutoStyle.method(:to_underscore), '%underscored')
        add_property_group(json_object, key, value, AutoStyle.method(:to_camel), '%CAPS_UNDERSCORE')
      end
    end


  private
    def self.add_property_group(json_object, key, value, translate, explicit_postfix)
      should_translate_val = value != nil && value.is_a?(String)

      new_key = translate.call(key)
      new_value = should_translate_val ? translate.call(value) : value

      try_add_prop(json_object, new_key, new_value)
      try_add_prop(json_object, new_key+explicit_postfix, new_value)
    end


    def self.try_add_prop(json_object, key, value)
      if !json_object.has_key?(key)
        json_object.store(key, value)
      end
    end


    def self.to_universal(input_string)
      output_string = input_string.tr('%', '')
      output_string.split(' ')
    end


    def self.to_cap_camel(input_string)
      universal = to_universal(input_string)
      universal.each {|word| word[0] = word[0].upcase}
      universal.join('')
    end


    def self.to_camel(input_string)
      universal = to_universal(input_string)
      universal[1...universal.count].each {|word| word[0] = word[0].upcase}
      universal.join('')
    end


    def self.to_underscore(input_string)
      universal = to_universal(input_string)
      output = universal.join('_')
      output.downcase
    end


    def self.to_allcaps_underscore(input_string)
      universal = to_universal(input_string)
      output = universal.join('_')
      output.upcase
    end
end


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






