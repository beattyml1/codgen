require 'mustache'
require 'handlebars'

module Codgen
  class TemplateProvider
    # @param [String] template: The template to be filled
    # @param [Hash] data: A hash of data model
    # @return [String]: The filled template
    def render(template, data)
      throw 'Not Implemented'
    end

    def name
      throw 'Not Implemented'
    end

    def extension
      throw 'Not Implemented'
    end
  end

  class MustacheTemplateProvider < TemplateProvider
    def render(template, data)
      Mustache.render(template, data)
    end

    def name
      'mustache'
    end

    def extension
      '.mustache'
    end
  end

  class HandleBarsTemplateProvider < TemplateProvider
    def render(template, data)
      handlebars = Handlebars::Context.new
      template = handlebars.compile(template)
      template.call(data)
    end

    def name
      'handlebars'
    end

    def extension
      '.handlebars'
    end
  end

  class StaticTemplateProvider < TemplateProvider
    def render(template, data)
      template
    end

    def name
      'static'
    end

    def extension
      nil
    end
  end

  class TemplateProviderList
    def initialize
      @by_ext = Hash.new
      @by_name = Hash.new
    end

    def add(template_provider)
      @by_name[template_provider.name] = template_provider
      if template_provider.extension != nil
        @by_ext[template_provider.extension] = template_provider
      end
    end

    def for_extension(extension)
      @by_ext[extension]
    end

    def named(name)
      @by_name[name]
    end
  end

  @@templates_providers = TemplateProviderList.new
  @@templates_providers.add(MustacheTemplateProvider.new)
  @@templates_providers.add(HandleBarsTemplateProvider.new)
  @@templates_providers.add(StaticTemplateProvider.new)

  def self.template_provider
    @@templates_providers
  end
end