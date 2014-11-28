module Codgen
  class TemplateProvider
    # @param [String] template: The template to be filled
    # @param [Hash] data: A hash of data model
    # @return [String]: The filled template
    def render(template, data)
      throw 'Not Implemented'
    end
  end

  class MustacheTemplateProvider < TemplateProvider
    def render(template, data)
      Mustache.render(template, data)
    end
  end

  class HandleBarsTemplateProvider < TemplateProvider
    def render(template, data)
      Mustache.render(template, data)
    end
  end

  class StaticTemplateProvider < TemplateProvider
    def render(template, data)
      template
    end
  end
end