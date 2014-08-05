require_relative '../regular_expressions'
require_relative 'section'
require_relative '../utilities/logger'

class Template < Section
  def fill(json_levels)
    value = get_template_value(name, json_levels)

    if value == nil
      ''
    elsif
      value.is_a?(Array)
      templates_output = ''
      value.each do |template_data|
        self.set_state_variable('is last template instance', template_data === value[-1])
        self.set_state_variable('is first template instance', template_data === value[0])

        template_output = super(Array.new(json_levels).insert(0, template_data))
        templates_output += template_output
      end
      templates_output
    else
      Logger.error('Only arrays can be injected into templates')
    end
  end
end
