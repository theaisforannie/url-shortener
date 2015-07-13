require 'sinatra'

# a hash for urls
# keys are short urls
# values are original urls
# TODO make an actual database idk
url_hash = {}

get '/' do
	erb :index
end

post '/' do
	url = params['original-url']
	# make the url into a short thing
	# TODO actually make the url shorter
	url_key = url.hash.to_s
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