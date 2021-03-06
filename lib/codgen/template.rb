require 'mustache'
require_relative 'flattener'
require_relative 'logger'
require_relative 'template_provider'

module Codgen
  class Template
    # @param [JSON_Hash] template_info
    # @param [JSON_Hash] data_root
    def initialize(template_info, data_root)
      @input_path = template_info['in']
      @out_raw = template_info['out']
      source_raw = template_info['source']
      source_location = source_raw != nil ? source_raw.split('.') : []
      @data = Flattener.merge(data_root, source_location)
      @template = Template.get_template(@input_path)
      @template_provider = Codgen.template_provider.named(template_info['template engine'])
      if @template_provider == nil
        @template_provider = Codgen.template_provider.for_extension(File.extname(@input_path))
      end
      if @template_provider == nil
        @template_provider = Codgen.template_provider.named('static')
      end
    end

    def fill_template
      if @data.is_a?(Array)
        output = Hash.new
        @data.each { |data|
          output.store(Mustache.render(@out_raw, data), @template_provider.render(@template, data))
        }
        return output
      elsif @data.is_a?(Hash)
      return { Mustache.render(@out_raw, data) => @template_provider.render(@template, data) }
      end
    end

    def self.get_template(path)
      if File.exist?(path)
        File.read(path)
      else
        Logger.error('Could not find file "'+path+'"')
      end
    end

    attr_reader :data, :input_path, :template # Used to unit test
  end
end