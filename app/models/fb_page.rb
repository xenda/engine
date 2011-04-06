class FBPage
	require 'net/http'
	require 'uri'
	require 'json'

	attr_accessor :id, :url, :data
	
	def initialize(id)
		self.id = id
		self.url = "http://graph.facebook.com/#{self.id}"
		self.data = ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse(self.url)).body)
	end
	
	def albums
		ActiveSupport::JSON.decode(Net::HTTP.get_response(URI.parse("#{self.url}/albums")).body)['data']
	end
end
