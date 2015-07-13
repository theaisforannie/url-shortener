require 'sinatra'

get '/' do
	erb :index
end

url_hash = {}
post '/' do
	url = params['original-url']
	url_key = url.hash.to_s
	url_hash[url_key] = url
	@short_url = "localhost:4567/#{url_key}"
	erb :index
end

get '/:foo' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  # "Hello #{params['name']}!"
  url_key = params['foo']
  original_url = url_hash[url_key]
  redirect to(original_url)
end