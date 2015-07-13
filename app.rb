require 'sinatra'

get '/' do
	erb :index
end

url_hash = {}
post '/' do
	url = params['original-url']
	url_key = url.hash.to_s
	url_hash[url_key] = url
	req_port = ""
	if request.port != 80
		req_port = ":#{request.port}"
	end
	@short_url = "#{request.scheme}://#{request.host}#{req_port}/#{url_key}"
	erb :index
end

get '/:foo' do
  url_key = params['foo']
  original_url = url_hash[url_key]
  redirect to(original_url)
end