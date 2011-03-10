module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
		
		def render(context)
			month_name = ::Date.today.strftime "%b"
			
			@events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_7.strftime("%b")==month_name }
			
			template = %{
			<% calendar_for(events, :year => 2011, :month => 3) do |t| %>
				<%= t.head('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun') %>
				<% t.day(:day_method => start_date) do |day, events| %>
					<%= day.day %><br />
					<% events.each do |event| %>
						<%= h(event.title) %><br />
					<% end %>
				<% end %>
			<% end %>
			}
			
			render_erb(context, template, :events => @events)
		end
		
		def render_erb(context, file_name, locals = {})
			::Liquid::Template.parse(file_name).render(locals, :registers=>{:controller => context.registers[:controller]})
			#if context
			#	context.registers[:controller].send(:render_to_string, :partial => file_name, :locals => locals)
			#else
			#	@context.registers[:controller].send(:render_to_string, :partial => file_name, :locals => locals)
			#end
		end
		
	end
	
	::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end