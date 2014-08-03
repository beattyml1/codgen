require_relative 'auto_style'
require_relative 'resources'
require_relative 'debug_helper'

class Template
public
  def initialize(parent, name, text = '')
    @parent = parent
    @name = name
    @remaining_text = ''
    @templates = Hash.new
    @text = text
    @state_variables = Hash.new
    @macros_unfilled = Hash.new
    @macros_filled = Hash.new
  end

  include Resources

  def parse(template_file)
    until template_file.eof
      line = template_file.readline

      macros = line.scan(MACRO_REGEX)
      if macros.count > 1
        Logger.error('Cannot have multiple macros on the same line')
      elsif macros.count == 1
        macro = macros[0]
        macro_name = macro.scan(IDENTIFIER_REGEX)[0]
          value = line.sub(macro, '').strip
          @macros_unfilled[macro_name] = value
        next
      end

      tags = line.scan(TEMPLATE_TAG_REGEX)
      if tags.count > 1
        Logger.error('Cannot have multiple template tags on the same line')
      elsif tags.count == 1
        tag = tags[0]
        if tag.index(TEMPLATE_START_TAG_REGEX)
          id = tag.scan(IDENTIFIER_REGEX)[1]
          template = Template.new(self, id)
          @templates.store(id, template)
          @text += '{{'+id+'}}'
          template.parse(template_file)
        elsif tag.index(TEMPLATE_END_TAG_REGEX)
          id = tag.scan(IDENTIFIER_REGEX)[1]
          if id == @name
            return
          else
            Logger.error('End tag encountered that that does not correspond with the current start tag')
          end
        else
          Logger.error("Tag's first word must be start or end and it's second must be  valid identifier")
        end
      else
        @text += line
      end
    end
  end


  def set_state_variable(name, value)
    AutoStyle.style_state_variable(name).each do |key|
      @state_variables[key] = value
    end
  end


  def fill(json_levels)
    @macros_unfilled.each do |key, value|
      @macros_filled[key] = do_inserts(json_levels, value)
    end
    text = do_inserts(json_levels, @text)
    do_switches(json_levels, text)
  end


  def name
    @name
  end

  def filename
    @macros_filled['filename']
  end

private
  def do_inserts(json_levels, input_text)
    text = String.new(input_text)
    inserts = text.scan(INSERT_REGEX)
    inserts.each do |insert|
      identifier = insert[IDENTIFIER_REGEX]
      template = @templates[identifier]
      value = get_template_value(identifier, json_levels)

      if template && value.is_a?(Array)
        templates_output = ''
        value.each do |template_data|

          template.set_state_variable('is last template instance', template_data === value[-1])
          template.set_state_variable('is first template instance', template_data === value[0])

          template_output = template.fill(Array.new(json_levels).insert(0, template_data))
          templates_output += template_output
        end

        text.sub!(insert, templates_output)
      elsif value == nil
        text.sub!(insert, '')
      elsif value.is_a?(String)
        text.sub!(insert, value)
      else
        Logger.error 'Currently only strings can be inserted into a template'
      end
    end
    text
  end

  def do_switches(json_levels, input_text)
    output = ''
    input_text.each_line do |line|
      show_line = true

      switches = line.scan(SWITCH_REGEX)

      switches.each do |switch|
        identifier = switch[IDENTIFIER_REGEX]
        value = get_template_value(identifier, json_levels)
        is_inverted = switch.index('!') != nil
        show_line &= is_inverted ? !value : value
      end

      if show_line
        output += line.sub(SWITCH_REGEX, '')
      end
    end

    output
  end

  def get_template_value(name, json_levels)
    json_levels.each do |level|
      if level.is_a?(Hash) && level.has_key?(name)
        return level[name]
      end
    end

    if @macros_filled.has_key?(name)
      @macros_filled[name]
    end

    if @state_variables.has_key?(name)
      @state_variables[name]
    end
  end
end
