module Locomotive
  module Liquid
    module Tags
      class GetCalendar < ::Liquid::Tag
    
    def render(context)
      params = context.registers[:controller].send(:get_params)
      week_begins = 0
      if params[:mes]
        thismonth = params[:mes].to_i
      else
        thismonth = ::Date.today.strftime("%m").to_i
      end
      if params[:y]
        thisyear = params[:y].to_i
      else
        thisyear = ::Date.today.strftime("%Y").to_i
      end
      ::I18n.locale = :es
      month_names = ::I18n.t('date.month_names')
      month_name = month_names[thismonth]
      
      unixmonth = ::Time.mktime(thisyear, thismonth, 1, 0, 0, 0, 0)
      last_day = ::Date.civil(thisyear, thismonth, -1).day
      
      previousmonth = thismonth
      previousyear = thisyear
      nextmonth = thismonth
      nextyear = thisyear
      
      if thismonth == 1
        previousmonth = 12
        previousyear -= 1
      else
        previousmonth -= 1
      end
      
      if thismonth == 12
        nextmonth = 1
        nextyear += 1
      else
        nextmonth += 1
      end
      
      previous_link = "<a href='?mes=#{previousmonth}&y=#{previousyear}' class='prev' style='opacity:0.5'>Anterior</a>"
      
      next_link = "<a href='?mes=#{nextmonth}&y=#{nextyear}' class='next' style='opacity:0.5'>Siguiente</a>"
      
      calendar_output = %{}
      calendar_output = %{<div class="month clearfix">
        #{previous_link}
        <h3>#{month_name} #{thisyear}</h3>
        #{next_link}</div>}
      
      calendar_output << %{<div class='schedule-container'>
        <table summary="Calendario">
          <thead>
            <tr>}
      
      day_names = ::I18n.t('date.day_names')
      abbr_day_names = ::I18n.t('date.abbr_day_names')
      
      (0..6).each do |n|
        calendar_output << %{<th scope="col" title="#{day_names[(n + week_begins)%7]}">#{abbr_day_names[(n + week_begins)%7]}</th>}
      end
      
      calendar_output << %{</tr>
        </thead>
        <tbody>
          <tr>}
      
      events = ::ContentType.where(:slug => "events").first.contents.select { |c| c.custom_field_8 >= ::Date.civil(thisyear, thismonth, 1) && c.custom_field_8 <= ::Date.civil(thisyear, thismonth, last_day) }
      
      dayswithevents = []
      
      events.each do |e| 
        event_range = e.custom_field_8.day..e.custom_field_9.day
        event_range.to_a.each do |day|
          dayswithevents << day 
         end
         
      end
      
      events_photos = []
      
      events_for_day = []
      
      unless events.empty?

        events.each do |event|
          event_ID = event._id
          event_title = event.custom_field_1
          event_day = event.custom_field_8.day
          event_range = event.custom_field_8.day..event.custom_field_9.day
          event_category = event.custom_field_7
          
          if event_day
            event_range.to_a.each do |day|
              	photo = event.custom_field_4_filename
              	assets = ::AssetCollection.first.assets.select{|a| a.source_filename == photo }
	            unless assets.empty?
	              asset = assets.first
	              site_id = asset.collection.site_id
	              asset_id = asset.id
	              url = "/sites/#{site_id}/assets/#{asset_id}/#{photo}"
	            end
	            url ||= ""
	            
	            events_for_day[day]  ||= "<div class='events' id='day_#{day}'>"
	            events_for_day[day] << "<div class='event'>"
	            events_for_day[day] << "	<div class='event_title #{event_category}' id='event_#{event_ID}_#{day}'></div>"
	            events_for_day[day] << "	<div class='event_photo' id='event_photo_#{event_ID}_#{day}'><a href='/events/#{event._slug}'><img src='#{url}' width='100%' /></a></div>"
	            events_for_day[day] << "</div>"
            end
          end
          
        end
        
        events_for_day.each{|e| e << "</div>" if e }
      end
      
      pad = calendar_week_mod(unixmonth.strftime("%w").to_i - week_begins)
      
      if 0 != pad
        calendar_output << %{<td colspan='#{pad}' class="pad"> </td>}
      end
      
      daysinmonth = last_day.to_i
      
      newrow = false
      
      (1..daysinmonth).each do |day|
        if newrow
          calendar_output << %{</tr>
            <tr>}
        end
        
        newrow = false
        
        if day == ::Date.today.day && thismonth == ::Date.today.month && thisyear == ::Date.today.year
          calendar_output << %{<td class='today'>}
        else
          calendar_output << %{<td>}
        end
        
        calendar_output << %{<div class='content'>}
        
        if dayswithevents.include?(day)
          calendar_output << %{<span class='day'>#{day}</span>
          #{events_for_day[day]}}
        else
          calendar_output << %{<span class='day'>#{day}</span>}
        end
        
        calendar_output << %{</div>
          </td>}
        
        if calendar_week_mod(::Time.mktime(thisyear, thismonth, day, 0, 0, 0, 0).strftime("%w").to_i - week_begins) == 6
          newrow = true
        end
      end
      
      pad = 7 - calendar_week_mod(::Time.mktime(thisyear, thismonth, daysinmonth, 0, 0, 0, 0).strftime("%w").to_i - week_begins)
      
      if pad != 0 && pad != 7
        calendar_output << %{<td class='pad' colspan='#{pad}'> </td>}
      end
      
      calendar_output << %{
            </tr>
          </tbody>
        </table>
      </div>
      }
    end
    
    def calendar
      #
    end
    
    private
      def calendar_week_mod(num)
        base = 7
        (num - base*(num/base))
      end
  end
  
  ::Liquid::Template.register_tag('getcalendar', GetCalendar)
    end
  end
end
