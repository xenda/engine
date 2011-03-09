module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
		
		def render(context)
			puts context.inspect
			%{
            	<b>calendario</b>
          	}
			#super
			#month_name = ::Date.today.strftime "%b"
			
			#@events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_7.strftime("%b")==month_name }
			
			#render_erb(context, 'shared/calendar', :events => @events)
		end
		
		#def render_erb(context, file_name, locals = {})
		#	context.registers[:controller].send(:render_to_string, :partial => file_name, :locals => locals)
		#end
		
	end
	
	::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end