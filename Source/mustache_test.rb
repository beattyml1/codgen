require 'mustache'

class Simple < Mustache
  def name
    "Chris"
  end

  def value
    10_000
  end

  def taxed_value
    value * 0.6
  end

  def in_ca
    true
  end
end

data = {'name!x' => 'Matthew', 'value' => 100, 'taxed_value' => 100, 'in_ca' => true, 'array' => [{'test' => 'hello '}]}

puts Mustache.render( 'Hello {{name!x}}
You have just won {{value}} dollars!
{{#in_ca}}
Well, {{taxed_value}} dollars, after taxes.
{{/in_ca}}
{{#array}}
  {{test}}{{name!x}}
{{/array}}
', data)


