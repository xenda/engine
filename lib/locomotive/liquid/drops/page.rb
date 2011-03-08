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
        	puts ::Page.criteria.id(@source.id).first.title
        	puts ::Page.criteria.id(@source.id).first.attributes
        	puts ::Page.criteria.id(@source.id).first.editable_elements.attributes
        	puts ::Page.criteria.id(@source.id).first.editable_elements.methods
        	::Page.criteria.id(@source.id).first.editable_elements
        end

      end
    end
  end
end
