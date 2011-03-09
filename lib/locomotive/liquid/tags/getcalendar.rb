module Liquid
  module Locomotive
    module Tags
      class GetCalendar < ::Liquid::Tag
				
				def initialize(tag_name, markup, tokens, context)
					
					super
					
					month_name = ::Date.today.strftime "%b"
					
					@events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_7.strftime("%b")==month_name }
					
				end
				
				def render(context)
					puts context.inspect
					puts "----------------"
					"calendar"
					#render_erb(context, 'shared/calendar', :events => @events)
				end
				
				def render_erb(context, file_name, locals = {})
					context.registers[:controller].send(:render_to_string, :partial => file_name, :locals => locals)
				end
				
			end
			
			::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end