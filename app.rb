require 'sinatra'
require 'sqlite3'

# a hash for urls
# keys are short urls
# values are original urls
# TODO make an actual database idk
url_hash = {}
db = SQLite3::Database.new "url-modifier.db"

def url_to_short_string()
	chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
	short_chars = ""
	while short_chars.length < 10
		short_chars << chars.sample
	end
	short_chars
end

def extraneous_long_url_characters()
  chars = ('A'..'Z').to_a + ('a'..'z').to_a + ('0'..'9').to_a
  extra_chars = ""
  while extra_chars.length < 500
    extra_chars << chars.sample
  end
  extra_chars
end

get '/short' do
	erb :index
end

post '/short' do
	url = params['original-url']
	# make the url into a short thing
	url_key = url_to_short_string()
	url_hash[url_key] = url
	db.execute "INSERT INTO url_enhancements (short_url, actual_url) VALUES(?, ?)", \
		[url_key, url]
	# generate short url
	req_port = ""
	if request.port != 80
		req_port = ":#{request.port}"
	end
	@short_url = "#{request.scheme}://#{request.host}/#{url_key}"

	erb :index
end

post '/long' do
  url = params['url-to-be-lengthened']
  url_key = url_to_short_string
  url_hash[url_key] = url
  db.execute "INSERT INTO url_enhancements (short_url, actual_url) VALUES(?, ?)", \
    [url_key, url]
  extraneous_chars = extraneous_long_url_characters
  req_port = ""
  if request.port != 80
    req_port = ":#{request.port}"
  end
  @long_url = "#{request.scheme}://#{request.host}/#{url_key}#{extraneous_chars}"
end

# ':foo' matches anything after '/'
# plain annie language: foo is the key of the params hash 
# at the time the shortened url is visited
get '/:foo' do
  url_key = params['foo'][0..9]
  db.execute "SELECT actual_url FROM url_enhancements WHERE short_url = '#{url_key}'" do |foo|
  	puts foo
  end


  if url_hash.has_key?(url_key)
  	original_url = url_hash[url_key]
  else
  	redirect to("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
  end
  redirect to(original_url)
end