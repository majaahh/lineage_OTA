require 'json'

module JekyllJson
  class JsonTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      if /(.+) (.+)/.match(@text)
        begin
          context[$1] = JSON.parse(context[$2].to_s)
        rescue
          context[$1] = {}
        end
        return ''
      end
      return ''
    end
  end
end

Liquid::Template.register_tag('json', JekyllJson::JsonTag)
