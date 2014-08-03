require_relative 'template'
require_relative 'auto_style'
require_relative 'mapping'
require_relative 'logger'

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


  def self.run(json_config)
    map = json_config['map']
    map = get_data_if_not_data(map)

    json_data  = json_config['data']
    json_data = get_data_if_not_data(json_data)
    json_data = map_and_style(map, json_data)

    File.write('temp.json', JSON.pretty_unparse(json_data)) # frequently used debug code

    filled_templates = Array.new

    templates = json_config['templates']
    templates.each do |template|
      template_path = template['in']
      template_file = File.open(template_path)
      source = template['source']
      output_path_template_text = template['out']
      output_path_template = Template.new(nil, nil, output_path_template_text)

      root_template = Template.new(nil, 'root')
      root_template.parse(template_file)

      if source != nil
        if !source.is_a?(String) || !json_data[source].is_a?(Array)
          Logger.error('source property of template must point to a array at root level in json data file')
        end

        instances = json_data[source]
        instances.each do |instance_data|
          json_object_chain = [instance_data, json_data]
          output_path = output_path_template.fill(json_object_chain)
          result = FilledTemplate.new
          result.text = root_template.fill(json_object_chain)
          result.path = output_path
          filled_templates.push(result)
        end
      else
        json_object_chain = [json_data]
        output_path = output_path_template.fill(json_object_chain)
        result = FilledTemplate.new
        result.text = root_template.fill(json_object_chain)
        result.path = output_path
        filled_templates.push(result)
      end
    end

    filled_templates
  end


  def self.get_data_if_not_data(filepath_or_data)
    if filepath_or_data != nil
      if filepath_or_data.is_a?(String)
        file = File.read(filepath_or_data)
        JSON.parse(file)
      elsif map.is_a?(Hash)
        filepath_or_data
      else
        Logger.error('In json config file: "map" must be either a filepath or a json object.')
      end
    end
  end


  def self.run_single_on_final_data(json_data, template_stream)
    root_template = Template.new(nil, 'root')
    root_template.parse(template_stream)

    filled_templates = Array.new

    if root_template.name != 'root'
      instances = json_data[root_template.name]
      instances.each do |json_instance|
        json_object_chain = [json_instance, json_data]
        result = FilledTemplate.new
        result.text = root_template.fill(json_object_chain)
        result.path = root_template.filename
        filled_templates.push(result)
      end
    else
      json_object_chain = [json_data]
      result = FilledTemplate.new
      result.text = root_template.fill(json_object_chain)
      result.path = root_template.filename
      filled_templates.push(result)
    end
    filled_templates
  end

  class FilledTemplate
    attr_accessor :path
    attr_accessor :text
  end

  def self.map_and_style(map_data, json_data)
    if map_data
      Mapping.map_object(json_data, map_data)
    end

    AutoStyle.style(json_data)

    json_data
  end
end