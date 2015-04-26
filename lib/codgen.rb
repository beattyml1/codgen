require_relative 'codgen/version'
require_relative 'codgen/auto_style'
require_relative 'codgen/mapping'
require_relative 'codgen/logger'
require_relative 'codgen/template'
require_relative 'codgen/package'
require 'net/http'

module Codgen
  def self.run(json_config)
    map = json_config['map']
    map = get_data_if_not_data(map)

    json_data  = json_config['data']
    json_data = get_data_if_not_data(json_data)
    json_data = map_and_style(map, json_data)

    #File.write('temp.json', JSON.pretty_unparse(json_data)) # frequently used debug code

    filled_templates = Array.new

    templates = json_config['templates']
    packages = json_config['packages']

    if packages != nil
      packages.each do |packageInfo|
        package = Package.new(packageInfo)
        templates.concat(package.templates)
      end
    end

    templates.each do |template_info|
      template = Template.new(template_info, json_data)
      template.fill_template.each {|filled_template| filled_templates.push(filled_template)}
    end

    filled_templates
  end

  def self.get_data_if_not_data(filepath_or_data)
    if filepath_or_data != nil
      if filepath_or_data.is_a?(String)
        if /https?:\/\//.match(filepath_or_data)
          resp = Net::HTTP.get_response(URI.parse(filepath_or_data))
          file = resp.body
        else
          file = File.read(filepath_or_data)
        end
        JSON.parse(file)
      elsif filepath_or_data.is_a?(Hash)
        filepath_or_data
      else
        Logger.error('In json config file: "map" must be either a filepath or a json object.')
      end
    end
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