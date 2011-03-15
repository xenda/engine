module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
		
		def render(context)
			month_name = ::Date.today.strftime "%b"
			
			@events = ::ContentType.where(:slug => "events").first.contents#.select { |c| c.custom_field_7.strftime("%b")==month_name }
			calendar(@events)
		end
		
		def calendar(events)
			events.each do |event|
				puts event.custom_field_1
				puts event.custom_field_7
				puts "-----------------"
			end
		end
		
	end
	
	::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end