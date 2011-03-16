module Admin
  class RenderingController < ActionController::Base

    include Locomotive::Routing::SiteDispatcher

    include Locomotive::Render

    before_filter :require_site

    before_filter :write_stuff
    
    def write_stuff
      logger.info Rails.env
      logger.info ENV['S3_KEY_ID']
      logger.info ENV['S3_SECRET_KEY']
      logger.info ENV['S3_BUCKET']
    end
    
    def get_params
    	puts request.inspect unless request.nil?
    	puts "--------------------------------"
    	puts params.inspect unless params.nil?
    end


    def show
      render_locomotive_page
    end

  end
end
