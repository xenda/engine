module Locomotive
  module Liquid
    module Tags
      class GetPage < ::Liquid::Block

        def initialize(tag_name, markup, tokens, context)
		    super
		    setup_options(markup)
		    if slug = options[:permalink].strip
		    	@slug = slug
		    end
		  end
		  
		  def render(context)
		        @slug = @slug.strip.gsub(" ", "")
			@page = ::Page.where(:slug => @slug).first
		  	context.scopes.last['_page'] = @page
	    		super
		  end
		  
		  private

			  def setup_options(options_list)
			    options_list = options_list.split(",")
			    if options_list.size == 1
			     options[:permalink] = options_list.first.gsub("\"","")
			    else
			     options[:key] = options_list.first.gsub("\"","").to_sym
			     options[:value] = options_list.last.gsub(" ","")
			    end
			  end
			
			  def options
			    @options ||= {}
			  end
      end

      ::Liquid::Template.register_tag('getpage', GetPage)
    end
  end
end
