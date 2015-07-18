require 'date'
require 'i18n'

path = File.expand_path("../../_locale/en.yml", __FILE__)
I18n.load_path = Dir[path]
I18n.locale = :'en'

module Jekyll
  module I18nFilter
    # Example:
    # {{ post.date | localize: "%d.%m.%Y" }}
    # {{ post.date | localize: ":short" }}
    def localize(input, format=nil)
      format = (format =~ /^:(\w+)/) ? $1.to_sym : format

      if input.is_a?(String)
        input = DateTime.parse(input)
      end

      I18n.l input, :format => format
    end

    def translate(key)
      I18n.t key
    end
  end
end

# Add as a filter
Liquid::Template.register_filter(Jekyll::I18nFilter)