module Liquid
  module Locomotive
    module Tags
      class GetPage < ::Liquid::Block

        def initialize(tag_name, markup, tokens, context)
		    super
		    slug = markup
		    @page = ::Page.where(:slug => slug).first
		  end
		  
		  def render(context)
		  	context.scopes.last['_page'] = @page
    		super
		  end
      end

      ::Liquid::Template.register_tag('getpage', GetPage)
    end
  end
end
