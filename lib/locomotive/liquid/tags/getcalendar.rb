module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
		
		def render(context)
			month = ::Date.today.strftime "%m"
			
			@events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_8.strftime("%m")==month }
			calendar(@events)
		end
		
		def calendar(events)
			events.each do |event|
				puts event.custom_field_8.strftime("%b")
				puts "-----------------"
			end
		end
		
	end
	
	::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end