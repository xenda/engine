class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :write_stuff
  def write_stuff
    logger.info Rails.env
    logger.info ENV['S3_KEY_ID']
    logger.info ENV['S3_SECRET_KEY']
    logger.info ENV['S3_BUCKET']
  end

  protected

  

  # rescue_from Exception, :with => :render_error
  #
  # def render_error
  #   render :template => "/admin/errors/500", :layout => '/admin/layouts/box', :status => 500
  # end
end
