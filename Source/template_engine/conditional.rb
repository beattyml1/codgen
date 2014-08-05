require_relative 'section'

class Conditional < Section
  def initialize(parent, name, previous_condition)
    @previous_condition = previous_condition
    @statement = nil
    @is_chosen_branch = nil
    super(parent, name)
  end

  attr_accessor :statement
  attr_reader :is_chosen_branch
  attr_reader :previous_condition

  def fill(json_levels)
    previous = @previous_condition
    was_previous_chosen = false
    until previous == nil
      if previous.is_chosen_branch
        was_previous_chosen = true
        break
      end
      previous = previous.previous_condition
    end

    get_val = Proc.new{|name| get_template_value(name, json_levels)}
    @is_chosen_branch =  !was_previous_chosen && (!@statement || @statement.evaluate(get_val))
    @is_chosen_branch ? super(json_levels) : nil
  end
end