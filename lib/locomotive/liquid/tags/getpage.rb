module Liquid
  module Locomotive
    module Tags
      class GetPage < ::Liquid::Block

        def initialize(tag_name, markup, tokens, context)
		    super 
		    setup_options(markup)
		    if slug = options[:slug]
		      @page = ::Page.where(:slug => slug).first
		    else
		      @page = Page.where(options[:key] => options[:value]).first
		    end
		  end
		  
		  def render(context)
		  	context.scopes.last['page'] = @page
    		super
	  	  end
      end

      ::Liquid::Template.register_tag('getpage', GetPage)
    end
  end
end
