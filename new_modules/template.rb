require 'mustache'
require_relative 'flattener'

class Template
  # @param [JSON_Hash] template_info
  # @param [JSON_Hash] data_root
  def initialize(template_info, data_root)
    @input_path = template_info['in']
    @out_raw = template_info['out']
    source_raw = template_info['source']
    source_location = source_raw.split('.')
    @data = Flattener.merge(data_root, source_location)
    @template = get_template(@input_path)
  end

  def fill_template
    if @data.is_a?(Array)
      output = Hash.new
      @data.each { |data| output.store(Mustache.render(@out_raw, data), Mustache.render(@template, data)) }
      return output
    elsif
      return { Mustache.render(@out_raw, data) => Mustache.render(@template, @data) }
    end
  end

  def self.get_template(path)
    if File.exist?(path)
      File.read(path)
    else
      Logger.error('Could not find file "'+path+'"')
    end
  end

  attr_reader :data, :input_path, :data # Used to unit test
end