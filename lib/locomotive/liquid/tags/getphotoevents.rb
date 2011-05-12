module Locomotive
  module Liquid
    module Tags
      class GetPhotoEvents < ::Liquid::Block
            def render(context)
                  @events = ::ContentType.where({:slug => "events"}).first.contents.select{|i| i.custom_field_4_filename }
                  context.scopes.last['events'] = @events
                  super
            end
      end

      ::Liquid::Template.register_tag('getphotoevents', GetPhotoEvents)
    end
  end
end
