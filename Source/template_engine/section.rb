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


  attr_reader :name
  attr_reader :parent
  attr_reader :macros_unfilled
  attr_reader :macros_filled
  attr_reader :sections
  attr_accessor :text

  private
  include RegularExpressions
end