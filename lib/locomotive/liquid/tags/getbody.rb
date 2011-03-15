module Locomotive
  module Liquid
    module Tags
      class GetBody < ::Liquid::Block
		  
		  def render(context)
		  	case context.registers[:page].fullpath
				when "index" then bodyclass = "home"
				when /events/ then bodyclass = "events"
				when "agenda" then bodyclass = "schedule"
				when "archivo" then bodyclass = "archive"
				else bodyclass = "inner"
			end
			context.registers[:page].fullpath
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
