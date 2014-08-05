require_relative '../regular_expressions'
require 'securerandom'
require_relative '../utilities/logger'

class Section
  public
  def initialize(parent, name, text = '')
    @parent = parent
    @name = name
    @remaining_text = ''
    @sections = Hash.new
    @text = text
    @state_variables = Hash.new
    @macros_unfilled = Hash.new
    @macros_filled = Hash.new
  end


  def set_state_variable(name, value)
    AutoStyle.style_state_variable(name).each do |key|
      @state_variables[key] = value
    end
  end


  def get_template_value(name, json_levels)
    json_levels.each do |level|
      if level.is_a?(Hash) && level.has_key?(name)
        return level[name]
      end
    end

    search_level = self
    until search_level == nil
      if @macros_filled.has_key?(name)
        return @macros_filled[name]
      end

      if @state_variables.has_key?(name)
        return @state_variables[name]
      end

      search_level = search_level.parent
    end
  end


  def fill(json_levels)
    @macros_unfilled.each do |key, value|
      @macros_filled[key] = do_inserts(json_levels, value)
    end
    text = do_inserts(json_levels, @text)
    do_switches(json_levels, text)
  end


  attr_reader :name
  attr_reader :parent
  attr_reader :macros_unfilled
  attr_reader :macros_filled
  attr_reader :sections
  attr_accessor :text

  private
  include RegularExpressions

  def do_inserts(json_levels, input_text)
    text = String.new(input_text)
    inserts = text.scan(INSERT_REGEX)
    inserts.each do |insert|
      identifier = insert[IDENTIFIER_REGEX]
      section = @sections[identifier]

      if section
        section_output = section.fill(json_levels)
        text.sub!(insert, section_output||'')
      else
        value = get_template_value(identifier, json_levels)
        if value == nil
          text.sub!(insert, '')
        elsif value.is_a?(String)
          text.sub!(insert, value)
        else
          Logger.error 'Currently only strings can be inserted into a template'
        end
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
end