class FBPage
	require 'net/http'
	require 'uri'
	require 'json'

	attr_accessor :id, :url
	
	def initialize(id)
		self.id = id
		self.url = "http://graph.facebook.com/#{self.id}"
	end
	
	def albums
		ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse("#{self.url}/albums")).body)['data']
	end
end

class FBAlbum
	require 'net/http'
	require 'uri'
	require 'json'
	
	attr_accessor :id, :url
	
	def initialize(id)
		self.id = id
		self.url = "http://graph.facebook.com/#{self.id}"
	end
	
	def photos
		ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse("#{self.url}/photos")).body)['data']
	end
end
