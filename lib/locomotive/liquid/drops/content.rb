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
        	contents = ::ContentType.where(:slug => "resources").first.contents
        	contents.select{|c| c[:custom_field_4] == @source._slug}
        end

  def summary
    @source.summary
  end
  
  def photo
    @source.photo
  end

	def gallery
		album_id = ""
		if @source.content_type.slug == "events"
			album_id = @source.custom_field_10.to_s
		elsif @source.content_type.slug.strip == "news" || @source.content_type.slug.strip == "articles"
			album_id = @source.custom_field_6.to_s
		end
		output = %{<ul class="gallery">
		}
		album = ::FBAlbum.new(album_id)
		if album.photos
			album.photos.map do |photo|
				output << %{<li>
					<a href="#{photo['source']}" rel="gallery_group" title="#{photo['name']}">
						<img src="#{photo['images'][1]['source']}" />
					</a>
				</li>}
			end
		end
		output << %{</ul>}
		output
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
