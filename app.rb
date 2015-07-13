require 'sinatra'

set :port, 80

# a hash for urls
# keys are short urls
# values are original urls
# TODO make an actual database idk
url_hash = {}

def url_to_short_string()
	chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
	short_chars = ""
	while short_chars.length < 10
		short_chars << chars.sample
	end
	short_chars
end

get '/' do
	erb :index
end

post '/' do
	url = params['original-url']
	# make the url into a short thing
	url_key = url_to_short_string()
	url_hash[url_key] = url
	# generate short url
	req_port = ""
	if request.port != 80
		req_port = ":#{request.port}"
	end
	@short_url = "#{request.scheme}://#{request.host}#{req_port}/#{url_key}"

	erb :index
end

# ':foo' matches anything after '/'
# plain annie language: foo is the key of the params hash 
# at the time the shortened url is visited
get '/:foo' do
  url_key = params['foo']
  original_url = url_hash[url_key]
  redirect to(original_url)
end