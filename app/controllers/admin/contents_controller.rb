module Admin
  class ContentsController < BaseController

    sections 'contents'

    before_filter :set_content_type

    respond_to :json, :only => :update

    def index
      @contents = @content_type.list_or_group_contents
    end


    def update_resources
      # if @content_type.slug=='events'
      #      resource_type = current_site.content_types.where(:slug => 'resources').first
      #      resources = []
      # 
      #      if params[:resource] && params[:resource][:custom_field_3]
      #        resources = params[:resource][:custom_field_3]
      #      end
      # 
      #      resources.each do |resource_file|
      #        resource = {:custom_field_3 => resource_file,
      #          :name => Time.zone.now,
      #          :custom_field_4 => @content._slug
      #        }
      #        resource_type.contents.create(resource)
      #      end
      #    end
    end

    def create
      @content = @content_type.contents.create(params[:content])
      update_resources
      respond_with(@content, :location => edit_admin_content_url(@content_type.slug, @content))
    end

    def update
      update! { 

        #         if @content_type.slug=='events'
        #           resource_type = current_site.content_types.where(:slug => 'resources').first
        # 
        #           if params[:resource] && params[:resource][:custom_field_3]
        #                 resources = params[:resource][:custom_field_3].to_a
        # 
        #                 resources.each do |resource_file|
        #                   resource = {:custom_field_3 => resource_file,
        #                         :name => Time.zone.now,
        #                         :custom_field_4 => @content._slug
        #                         }
        #                   resource_type.contents.create(resource)
        #               end
        #             end
        # end
        edit_admin_content_url(@content_type.slug, @content.id) 
        
        
        
        }
      
    end

    def sort
      @content_type.sort_contents!(params[:order])

      respond_with(@content_type, :location => admin_contents_url(@content_type.slug))
    end

    def destroy
      destroy! do |format|
      	format.html { admin_contents_url(@content_type.slug) }
      	format.js  {render :layout => false }
      end
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
