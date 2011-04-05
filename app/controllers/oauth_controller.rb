require 'net/http'
require 'uri'

class OauthController < ApplicationController
  
  def facebook_register    
    if current_user.fb_token?
      @access_token = OAuth2::AccessToken.new(fb_client , current_user.fb_token)
      facebook_process
    else
    redirect_to fb_client.web_server.authorize_url(
           :redirect_uri => fb_redirect_uri,
           :scope => 'email,offline_access,manage_pages,publish_stream'
         )    
    end
  end
  
  def facebook_callback
    @access_token = fb_client.web_server.get_access_token(params[:code], :redirect_uri => fb_redirect_uri)
    logger.info @access_token.get("/me")
    current_user.fb_token = @access_token.token
    current_user.save
    facebook_process
  end
  
  private
  
  def fb_redirect_uri
       uri = URI.parse(request.url)
       uri.path = '/admin/fbconnect/callback'
       uri.query = nil
       uri.to_s
     end
  
  def fb_client
    OAuth2::Client.new('171023762925483', '34fd8cf7421dbef029d601adfaca82c3', :site => 'https://graph.facebook.com')
  end
      
  def facebook_process
    accounts = JSON.parse @access_token.get("/me/accounts")
    access_token = accounts["data"].select{|d| d["id"] == "75593379138"}.first["access_token"]
    
    page_access_token = OAuth2::AccessToken.new(fb_client, access_token)
    logger.info page_access_token.get("/me")      
  end
  
  
end