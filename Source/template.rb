require_relative 'auto_style'
require_relative 'resources'

class Template
public
  def initialize(parent, name)
    @parent = parent
    @name = name
    @remaining_text = ''
    @templates = Hash.new
    @text = ''
    @state_variables = Hash.new
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


  def set_state_variable(name, value)
    AutoStyle.style_state_variable(name).each do |key|
      @state_variables[key] = value
    end
  end


  def fill(json_levels)
    text = String.new(@text)

    inserts = text.scan(INSERT_REGEX)
    inserts.each do |insert|
      identifier = insert[IDENTIFIER_REGEX]
      template = @templates[identifier]
      value = get_template_value(identifier, json_levels)

      if template && value.is_a?(Array)
        templates_output = ''
        value.each do |template_data|
          template_output = template.fill(Array.new(json_levels).insert(0, template_data))
          templates_output += template_output
        end
        text.sub!(insert, templates_output)
      elsif value == nil
        text.sub!(insert, '')
      elsif value.is_a?(String)
        text.sub!(insert, value)
      else
        puts 'Currently only strings can be inserted into a template'
        exit 1
      end
    end

    switched_lines = text.scan(SWITCHED_LINE_REGEX)
    switched_lines.each do |switched_line|
      show_line = true

      switches = switched_line.scan(SWITCH_REGEX)
      switches.each do |switch|
        identifier = switch[IDENTIFIER_REGEX]
        value = get_template_value(identifier, json_levels)
        is_inverted = switch.index('!') != nil
        show_line &= is_inverted ? !value : value
      end

      if show_line
        switches.each do |switch|
          text.sub!(switch, '')
        end
      else
        line_start = text.index(switched_line)
        text.sub!(switched_line, '')
        text = text[0...line_start-1] + text[line_start...text.length]
      end
    end

    text
  end


  def name
    @name
  end


private
  include Resources
  def get_template_value(name, json_levels)
    json_levels.each do |level|
      if level.is_a?(Hash) && level.has_key?(name)
        return level[name]
      end
    end

    if @state_variables.has_key?(name)
      return @state_variables[name]
    end
  end


  def get_next_word
    @remaining_text = @remaining_text.lstrip

    id = ''

    while is_id_char(@remaining_text[0])
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
    first_match = input_string.index(/[a-zA-Z0-9_%$#]/)
    first_match == 0
  end
end
