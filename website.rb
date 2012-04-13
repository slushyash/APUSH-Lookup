require 'sinatra'
require 'rubygems'

$content = []

(2..34).each do |i|
	$content[i] = File.open("content/#{i}.txt", "rb").read.downcase
end
$content[0] = ""
$content[1] = ""

get '/' do
	erb :index
end

get '/result/:term' do
	term = params[:term].downcase
	chapters_having_term = []
	$content.each_with_index do |text, index|
		puts index.to_s
		if $content[index].include?(term)
			chapters_having_term << index
		end
	end
	halt chapters_having_term.to_s
end
