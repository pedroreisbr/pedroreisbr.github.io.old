require 'pp'
require 'pry'

module Jekyll
  module ListToHtml
    def listToHtml(_hash)
      @text="<table>"
      convert(_hash)
      @text="#{@text}</table>"
      _hash = @text
    end

    def convert(_hash)
      _hash.each do |key, value|
        if value.class == Array || value.class == Hash
          @text="#{@text}<tr>"
          @text="#{@text}<td>"
          @text="#{@text}#{key}"
          @text="#{@text}</td>"
          @text="#{@text}<td>"
          @text="#{@text}<table>"
          convert(value)
          @text="#{@text}</table>"
          @text="#{@text}</td>"
          @text="#{@text}</tr>"
        elsif key.class == Array || key.class == Hash
          convert(key)
        else
          @text="#{@text}<tr>"
          @text="#{@text}<td>"
          @text="#{@text}#{key}"
          @text="#{@text}</td>"
          @text="#{@text}<td>"
          @text="#{@text}#{value}"
          @text="#{@text}</td>"
          @text="#{@text}</tr>"
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::ListToHtml)