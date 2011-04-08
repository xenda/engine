module Locomotive
  module Liquid
    module Tags

      #
      # {% facebook_tags }
      #      
      class FacebookTags < ::Liquid::Tag

        Syntax = /(#{::Liquid::Expression}+)?/

        def initialize(tag_name, markup, tokens, context)
          if markup =~ Syntax
            @options = {}
            markup.scan(::Liquid::TagAttributes) { |key, value| @options[key.to_sym] = value.gsub(/"|'/, '') }  
          else
            raise ::Liquid::SyntaxError.new("Syntax Error in 'facebook_tags' - Valid syntax: nav og_type: og_url: og_")
          end
          super
        end

        def render(context)
          
          	case context.registers[:page].fullpath
      				when /index/ 
      				when /events/
                @options[:og_title] = context.registers[:page].title
                @options[:og_url] = "http://peru.info/events/#{context.registers[:page].slug}"
                @options[:description] = context.registers[:page].contents[0..150]                				  
      				when /agenda/ then "schedule"
      				when /archivo/ then "archive"
      				else 
                @options[:og_title] = context.registers[:page].title
                @options[:og_url] = "http://peru.info/news/#{context.registers[:page].slug}"
                @options[:og_image] = context.registers[:page].photo
                @options[:description] = context.registers[:page].contents[0..150]
      			end

          output = %Q{ <meta property="og:title" content="#{@options[:og_title]}" />
           <meta property="og:type" content="country" />
           <meta property="og:url" content="#{@options[:og_url]}" />
           <meta property="og:image" content="#{@options[:og_image]}" />
           <meta property="og:site_name" content="PeruInfo" />
           <meta property="og:description" content="#{@options[:description]}"/>
          } 
          
          output
        end

        ::Liquid::Template.register_tag('facebook_tags', FacebookTags)
      end
    end
  end
end
