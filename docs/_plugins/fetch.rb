require 'net/http'

module JekyllFetch
  class JsonFetchTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = text
    end

    def render(context)
      if /(.+) (.+)/.match(@text)
        begin
          base_url = context[$2]
          url = base_url.to_s.strip
          # skip empty or obviously invalid bodies from previous fetch (e.g. "404: Not Found")
          if url.empty? || url.include?(' ')
            context[$1] = ''
            return ''
          end
          resp = Net::HTTP.get_response(URI.parse(url))
          context[$1] = resp.body || ''
        rescue
          context[$1] = ''
        end
        return ''
      end
      return ''
    end
  end
end

Liquid::Template.register_tag('fetch', JekyllFetch::JsonFetchTag)
