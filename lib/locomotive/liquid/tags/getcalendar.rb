module Locomotive
	module Liquid
		module Tags
			class GetCalendar < ::Liquid::Block
				
				def initialize(tag_name, markup, tokens, context)
					
					super
					if params[:m]
						month_name = params[:m]
					else
						month_name = ::Date.today.strftime "%b"
					end
					
					@events = ::ContentType.where(:slug => "events").first.contents.select{ |c| c[:custom_field_7].strftime "%b" == month_name }
					
					render :partial => 'shared/calendar'
					
				end
				
			end
			
			::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end