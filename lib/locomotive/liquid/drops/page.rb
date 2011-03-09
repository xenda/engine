module Locomotive
  module Liquid
    module Drops
      class Page < Base

        def title
          @source.templatized? ? @context['content_instance'].highlighted_field_value : @source.title
        end

        def slug
          @source.templatized? ? @source.content_type.slug.singularize : @source.slug
        end

        def children
          @children ||= liquify(*@source.children)
        end

        def fullpath
          @fullpath ||= @source.fullpath
        end

        def depth
          @source.depth
        end
        
        def editable_elements
        	elements = []
        	attributes = ::Page.criteria.id(@source.id).first.attributes['editable_elements'].each do |element|
        		element = element.to_s.gsub("BSON::ObjectId('", "").gsub("'),", ",").gsub("=>", ":")
        		element = ActiveSupport::JSON.decode(element)
        		puts element.inspect
        		puts "------"
        		elements << element
        	end
        	puts elements
        	elements
        end

      end
    end
  end
end
