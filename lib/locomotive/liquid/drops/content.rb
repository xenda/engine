module Locomotive
  module Liquid
    module Drops
      class Content < Base

        def before_method(meth)
          return '' if @source.nil?

          if not @@forbidden_attributes.include?(meth.to_s)
            value = @source.send(meth)
          end
        end
        
        def resources
        	ContenType.find_by_slug('event').where("event='breaking_bad_logo'")
        end

        def highlighted_field_value
          @source.highlighted_field_value
        end

      end
    end
  end
end
