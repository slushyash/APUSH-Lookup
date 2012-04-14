require 'sinatra'
require 'redis'
require 'uri'


configure do
	# When the application loads, put the text file information into memory
	# global variables are stupid, but hey, this is a small program
	$content = []
	$content[0] = ""
	$content[1] = ""
	(2..34).each do |i|
		$content[i] = File.open("content/#{i}.txt", "rb").read.downcase
	end

	# Configure the redis instance for user-contributed lookups
	uri = URI.parse('redis://redistogo:dcf879b4a42316b82526f8ae7cdbdac6@drum.redistogo.com:9168')
	REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
end

def another_term(chapter, term)
	REDIS.rpush term, chapter
end

get '/' do
	erb :index
end

post '/' do
	@term = params[:term].downcase
	chapters_from_notes = []
	$content.each_with_index do |text, index|
		if $content[index].include?(@term)
			chapters_from_notes << index
		end
	end
	user_contributed_results = REDIS.lrange @term, 0, -1
	user_contributed_results = user_contributed_results.collect { |chapter| chapter.to_i }
	@chapters_having_term = (user_contributed_results + chapters_from_notes).sort!.uniq
	puts user_contributed_results
	erb :result
end

post '/addterm/?' do
	another_term(params[:chapter].to_i, params[:term])
	redirect '/'
end