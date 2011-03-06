module Locomotive
  module Liquid
    module Drops
      class Content < Base
      	
      	def initialize(source)
		  @id = source.id
		  super(source)
		end

        def before_method(meth)
          return '' if @source.nil?

          if not @@forbidden_attributes.include?(meth.to_s)
            value = @source.send(meth)
          end
        end
        
        def resources
        	#::ContentType.find(:all, :conditions => {:slug => "resources"}).where("contents.custom_field_4" => @source._slug)
        	#::ContentType.logger = ::Logger.new(STDOUT)
        	contents = ::ContentType.where(:slug => "resources").contents
        	contents.select{|c| c[:custom_field_4] == @source._slug}
        end
        
        def id
        	@id.to_s
        end
        
        def site_id
        	@context.registers[:site].id.to_s
        end

        def highlighted_field_value
          @source.highlighted_field_value
        end

      end
    end
  end
end
