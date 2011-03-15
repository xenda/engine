module Locomotive
  module Liquid
    module Tags
      class GetBody < ::Liquid::Block
		  
		  def render(context)
		  	bodyclass = case context.registers[:page].fullpath
				when /index/ then "home"
				when /events/ then "events"
				when /agenda/ then "schedule"
				when /archivo/ then "archive"
				else "inner"
			end
		  end
      end

      ::Liquid::Template.register_tag('getbody', GetBody)
    end
  end
end
