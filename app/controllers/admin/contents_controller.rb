module Admin
  class ContentsController < BaseController

    sections 'contents'

    before_filter :set_content_type

    respond_to :json, :only => :update

    def index
      @contents = @content_type.list_or_group_contents
    end

    def create
      @content = @content_type.contents.create(params[:content])
      
      if @content_type.name.downcase=='events'
      	resource_type = current_site.content_types.where(:slug => 'resources').first
      	params[:resource] << {:custom_field_4 => @content._slug}
      	resource = resource_type.contents.create(params[:resource])
      	
      	logger.debug resource.inspect
      	
      end
      
      respond_with(@content, :location => edit_admin_content_url(@content_type.slug, @content))
    end

    def update
      update! { edit_admin_content_url(@content_type.slug, @content) }
    end

    def sort
      @content_type.sort_contents!(params[:order])

      respond_with(@content_type, :location => admin_contents_url(@content_type.slug))
    end

    def destroy
      destroy! { admin_contents_url(@content_type.slug) }
    end

    protected

    def set_content_type
      @content_type ||= current_site.content_types.where(:slug => params[:slug]).first
    end

    def begin_of_association_chain
      set_content_type
    end

  end
end
