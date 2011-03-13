module Locomotive
  module Liquid
    module Tags
      class GetPage < ::Liquid::Block

        def initialize(tag_name, markup, tokens, context)
		    super
		    setup_options(markup)
		    if slug = options[:permalink].strip
		    	@slug = options[:permalink];
		    end
		  end
		  
		  def render(context)
		    @page = ::Page.where(:slug => @slug).first
		    puts @page.title
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
