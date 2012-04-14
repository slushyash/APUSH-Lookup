require 'sinatra'

$content = []
$content[0] = ""
$content[1] = ""
(2..34).each do |i|
	$content[i] = File.open("content/#{i}.txt", "rb").read.downcase
end

get '/' do
	erb :index
end

post '/' do
	term = params[:term].downcase
	@chapters_having_term = []
	$content.each_with_index do |text, index|
		if $content[index].include?(term)
			@chapters_having_term << index
		end
	end
	erb :result
end
