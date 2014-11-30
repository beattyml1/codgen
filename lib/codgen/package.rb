require_relative 'logger'
require 'json'
require 'fileutils'
require 'zip'

module Codgen
  class Package
    def initialize(package_info)
      if package_info.is_a?(String)
        @input_path = package_info
      elsif package_info.is_a?(Hash)
        @input_path = package_info['path']
        if @input_path == nil
          Logger.error 'Required property of package "path" was not found'
        end
      else
        Logger.error 'Invalid package path format'
      end

      @unpacked_path = ''

      if File.directory?(@input_path)
        @unpacked_path = @input_path
      elsif File.extname(@input_path) == '.zip'
        @unpacked_path = File.basename(@input_path, '.zip')
        unzip_file(@input_path)
      else
        Logger.error "Invalid package #{@input_path}: should be a zip or a directory"
      end

      config_path = "#{@unpacked_path}/config.json"
      config_file = File.read(config_path)
      @config = JSON.parse(config_file)
      @templates = @config['templates']
      @templates.each { |t| t['in'] = "#{@unpacked_path}/templates/#{t['in']}"}
    end

    attr_reader :config, :templates, :unpacked_path

    private
    def unzip_file (file)
      Zip::File.open(file) do |zip_file|
        zip_file.each do |f|
          f_path = f.name
          if File.directory?(f_path)
            FileUtils.rm_rf(f_path)
          end
          FileUtils.mkdir_p(File.dirname(f_path))
          f.extract(f_path)
        end
      end
    end
  end
end