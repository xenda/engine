module Locomotive
  module Liquid
    module Tags
      class GetBody < ::Liquid::Block
		  
		  def render(context)
		  	case request.fullpath.to_s
				when "/" then "home"
				when /events/ then "events"
				when "/agenda" then "schedule"
				when "/archivo" then "archive"
				else "inner"
			end
    		super
		  end
		  
		  private
			def starts_with?(prefix)
			  prefix = prefix.to_s
			  self[0, prefix.length] == prefix
			end
      end

      ::Liquid::Template.register_tag('getbody', GetBody)
    end
  end
end
