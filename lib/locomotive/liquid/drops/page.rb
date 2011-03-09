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
        	attributes = ::Page.criteria.id(@source.id).first.attributes.to_a
        	puts attributes['editable_elements'].inspect
        	puts attributes['editable_elements'].class
        	#::Page.criteria.id(@source.id).first.attributes[:editable_elements].select{|c| c[:custom_field_4] == @source._slug}
        	#::Page.criteria.id(@source.id).first
        	attributes['editable_elements']
        end

      end
    end
  end
end
