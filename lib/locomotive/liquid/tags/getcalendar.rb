module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
		
		def render(context)
			calendar
		end
		
		def calendar
			myweek = []
			week_begins = 0
			thismonth = ::Date.today.strftime("%m").to_i
			thisyear = ::Date.today.strftime("%Y").to_i
			
			month_name = ::Date.today.strftime("%B")
			
			unixmonth = ::Time.mktime(thisyear, thismonth, 1, 0, 0, 0, 0)
			last_day = ::Date.civil(thisyear, thismonth, -1).day.to_i
			
			previous_events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_8.strftime("%m").to_i == thismonth-1 }
			
			next_events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_8.strftime("%m").to_i == thismonth+1 }
			
			if previous_events.empty?
				previous_link = "<a class='prev' style='opacity:0.5'></a>"
			else
				previous_link = "<a href='?mes=#{thismonth-1}&y=#{thisyear}' class='prev' style='opacity:0.5'>Anterior</a>"
			end
			
			if next_events.empty?
				next_link = "<a class='next' style='opacity:0.5'></a>"
			else
				next_link = "<a href='?mes=#{thismonth+1}&y=#{thisyear}' class='next' style='opacity:0.5'>Siguiente</a>"
			end	
			
			calendar_output = %{<div class='month clearfix'>
				#{previous_link}
				<h3>#{month_name} #{thisyear}</h3>
				#{next_link}
			}
			
			calendar_output << %{<div class='schedule-container'>
				<table summary="Calendario">
					<thead>
						<tr>
			}
			
			[0..6].each do |n|
				myweek << (n+week_begins)%7 #Cambiar por nombres de dias de la semana
			end
			
			myweek.each do |w|
				day_name = w
				calendar_output << %{
						<th scope="col" title="#{w}">#{day_name}</th>
				}
			end
			
			calendar_output << %{
					</tr>
				</thead>
				<tbody>
					<tr>
				}
			
			events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_8 >= ::Date.civil(thisyear, thismonth, 1) && c.custom_field_8 <= ::Date.civil(thisyear, thismonth, last_day) }
			dayswithevents = []
			events.each{ |e| dayswithevents << e.custom_field_8.day }
			
			events_photos = []
			
			events_for_day = []
			
			unless events.empty?
				events.each do |event|
					event_ID = event._id
					event_title = event.custom_field_1
					event_day = event.custom_field_8.day
					event_category = event.custom_field_7
					
					if events_photos[event_day].nil?
						photo = event.custom_field_4_filename
						unless photo.nil?
							events_photos[event_day] = "<img src='#{event.custom_field_4_filename}' width='107' heigth='81' />"
						end
					end
					
					if events_for_day[event_day].nil?
						events_for_day[event_day] = "<div class='events'><div class='event #{event_category}'></div>"
					else
						events_for_day[event_day] << "<div class='event #{event_category}'></div>"
					end
					
					events_for_day[event_day] << "</div>";
				end
			end
			
			pad = calendar_week_mod(unixmonth.strftime("%w").to_i-week_begins)
			
			if pad!=0
				calendar_output << %{
						<td colspan='#{pad}' class="pad"> </td>
				}
			end
			
			daysinmonth = last_day.to_i
			
			[1..daysinmonth].each do |day|
				if newrow.present? && newrow
					calendar_output << %{
						</tr>
						<tr>
					}
				end
				newrow = false
				
				if day = ::Date.today.day && thismonth == ::Date.today.month && thisyear == ::Date.today.year
					calendar_output << %{<td class ='today'>}
				else
					calendar_output << %{<td>}
				end
				
				calendar_output << %{<div class='content'>}
				
				if dayswithevents.include?(day)
					calendar_output << %{events_photos[day]
					<span class='day'>#{day}</span>#{events_for_day[day]}}
				else
					calendar_output << %{<span class='day'>#{day}</span>}
				end
				
				calendar_output << %{</div>
					</td>
				}
				
				if calendar_week_mod(::Time.mktime(thisyear, thismonth, day, 0, 0, 0, 0).strftime("%w").to_i-week_begins)==6
					newrow = true
				end
			end
			
			pad = 7 - calendar_week_mod(::Time.mktime(thisyear, thismonth, day, 0, 0, 0, 0).strftime("%w").to_i-week_begins)
			
			if pad!=0 && pad!=7
				calendar_output << %{
					<td class='pad' colspan='#{pad}'> </td>
				}
			end
			
			calendar_output << %{
						</tr>
					</tbody>
				</table>
			</div>
			}
			puts calendar_output
		end
		
		private
			def calendar_week_mod(num)
				base = 7
				(num - base*floor(num/base))
			end
	end
	
	::Liquid::Template.register_tag('getcalendar', GetCalendar)
		end
	end
end