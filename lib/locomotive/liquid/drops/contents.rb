module Locomotive
  module Liquid
    module Drops
      class Contents < ::Liquid::Drop

        def before_method(meth)
          if meth.to_s=="events_with_photos"
              meth = :events
              @events_with_photos = true
          end

          type = @context.registers[:site].content_types.where(:slug => meth.to_s).first
          ProxyCollection.new(type)
        end

      end

      class ProxyCollection < ::Liquid::Drop

        def initialize(content_type)
          @content_type = content_type
          @collection = nil
        end

        def first
          self.collection.first
        end

        def last
          self.collection.last
        end

        def each(&block)
          self.collection.each(&block)
        end
        
        def size
          self.collection.size
        end
       
        def empty?
          self.collection.empty?
        end
       
        def any?
          self.collection.any?
        end

        def api
          { 'create' => @context.registers[:controller].send('admin_api_contents_url', @content_type.slug) }
        end
        
        def before_method(meth)
          klass = @content_type.contents.klass # delegate to the proxy class
          if (meth.to_s =~ /^group_by_.+$/) == 0
          	klass.send(meth, :ordered_contents)
          else
            klass.send(meth)
          end
        end

        protected

        def paginate(options = {})
          @collection = self.collection.paginate(options)
          {
            :collection       => @collection,
            :current_page     => @collection.current_page,
            :previous_page    => @collection.previous_page,
            :next_page        => @collection.next_page,
            :total_entries    => @collection.total_entries,
            :total_pages      => @collection.total_pages,
            :per_page         => @collection.per_page
          }
        end

        def collection
          	if @content_type.slug=='events'
			if @events_with_photos
				@collection ||= @content_type.contents.select{|i| i.custom_field_4_filename }

				puts '------------------------------------------------------------------------'
				puts @collection
				puts '------------------------------------------------------------------------'
			else
				@collection ||= @content_type.ordered_events
			end
           	else
           		@collection ||= @content_type.ordered_contents(@context['with_scope'])
           	end
        end
      end
    end
  end
end
