require_relative 'template'
require_relative 'auto_style'
require_relative 'mapping'

module CodgenEngine
  def self.run_single(json_data, template_stream, map_data)
    json_data = map_and_style(map_data, json_data)
    run_single_on_final_data(json_data, template_stream)
  end


  def self.run_multiple(json_data, templates_enumerable, map_data)
    json_data = map_and_style(map_data, json_data)
    templates_enumerable.each do |template|
      run_single_on_final_data(json_data, template)
    end
  end


  def self.run_single_on_final_data(json_data, template_stream)
    json_object_chain = [ json_data ]
    root_template = Template.new(nil, 'root')
    root_template.parse(template_stream)
    root_template.fill(json_object_chain)
  end


  def self.map_and_style(map_data, json_data)
    if map_data
      Mapping.map_object(json_data, map_data)
    end

    AutoStyle.style(json_data)

    json_data
  end
end