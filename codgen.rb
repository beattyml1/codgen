#!/usr/bin/env ruby
require 'ostruct'
require 'json'

# This is not a thread safe object!
class Template
  def initialze(parent, name)
    @parent = parent
    @name = name
    @remaining_text = ""
    @templates = []
  end


  def parse(remaining_text)
    @remaining_text = remaining_text

    loop do 
      template_tag_start_index = @remaining_text.index('<<<')
      before_text = [0..template_tag_start_index]
      @text += before_text  

      @remaining_text = @remaining_text[template_tag_start_index+3...@remaining_text.length]

      tag_type = get_next_word(@remaining_text)

      template_name = get_next_word(@remaining_text)

      template_tag_end_index = @remaining_text.index('<<<')

      if tag_type == 'start'
        template = Template.new(this, template_name)
        @templates.push(template)
        @text += "{{"+template_name+"}}"
        template.parse(@remaining_text)
      elsif tag_type == 'end'
        if template_name == @name
          return
        else
          throw "Template close tag '"+template_name+"' does not match template start tag '"+@name+"'"
        end
      else
        throw "Expected template end tag for '"+@name+"' encounterd end tag for '"+template_name+"'" 
      end
    end
  end


  def fill(current_object_chain) # input can be either an object or an array
    current_level = current_object_chain[0]

    if current_level.is_a?(Array)
      current_level.each_with_index do |instance, index|
        output += get_fill_single(instance, current_object_chain)
      end
    elsif current_level.is_a?(Hash)
      output = get_fill_single(current_level, current_object_chain)
    else
      throw "Invalid input type to function fill. Must be either an Arrray or a Hash"
    end

    return output 
  end


  def get_fill_single(current_level, levels)
    @templates.each do |template|
      next_level = current_level[template.name]
      next_levels = Array.new(levels)
      next_levels.insert(0, next_level)

      current_filled_template = get_fill_single_field(template.name, template.fill(next_levels), current_filled_template)
    end

    levels.each do |level|
      level.each do |key, value|
        current_filled_template = get_fill_single_field(key, value, current_filled_template)
        current_filled_template = get_fill_single_switch(key, value, current_filled_template)
      end
    end

    return current_filled_template
  end


  def get_fill_single_field(name, value, current_filled_template)
  	current_filled_template.replace('{{'+name+'}}', value)
  end


  def get_fill_single_switch(name, value, current_filled_template)
  	regex = Regexp.new('^*##:'+name+'\?*$') # Should match lines ending with ##:name?
  	matches = current_filled_template.scan(''\\? '+name')

    if value
	  matches.each do |match|
	    current_filled_template.gsub(match, match.gsub('##:name?'))
	  end
	else
		matches.each_char do |match|
		  match.gsub(match)
		end
    end
  end


  def get_next_word()
    @remaining_text.lstrip

    id = ""
    while is_id_char(@remaining_text[0])
      id += @remaining_text[0]

      if @remaining_text.length > 1
        @remaining_text = @remaining_text[1...@remaining_text.length]
      else 
        throw "Expected end of tag or next word"
      end
    end

    @remaining_text.rstrip

    return id
  end


  def is_id_char(input_string)
    return (/^[a-zA-Z0-9_]$/.match(input_string))
  end
end


def get_args()
  return_obj = OpenStruct.new
  return_obj.json_data_filename = ARGV[0]
  return_obj.template_filename = ARGV[1]
  return_obj.output_filename = ARGV[2]
  return return_obj
end


def get_file_contents(filepath)
  return File.read(filepath)
end


def write_file_contents(filepath, content)
  File.write(filepath, content)
end


def main(args)
  json_data = get_file_contents(args.json_data_filename)
  template_text = get_file_contents(args.template_filename)
  json_object_chain = [ JSON.parse(json_data) ]
  root_template = Template.new(nil, "root")
  root_template.parse(template_text)
  output = root_template.fill(json_object_chain)
  write_file_contents(args.output_filename, output)
end

main(get_args())






