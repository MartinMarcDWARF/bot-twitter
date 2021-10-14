require 'pry'
require 'dotenv'
require 'twitter'

## to call your API keys
Dotenv.load('../.env')

journalists = ["@frontendmenteur", "@luuucasog", "@8UK0W5K1", "charleedouard1", "@mrprst", "@L_ChamCham", "@lamour_ronan", "@bigdduwa", "@nathvideobot"]

## Call Twitter API keys and connect to it normal mode
def rest_connection
  client_rest = Twitter::REST::Client.new do |config|
   config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
   config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
   config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
   config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
  return client_rest
end

## Call Twitter API keys and connect to it in streaming mode
def streaming_connection
  client_stream = Twitter::Streaming::Client.new do |config|
   config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
   config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
   config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
   config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"]
  end
    return client_stream
end

## This select 5 journalists in the array journalists
journalists_to_tweet = 5.times.map{ journalists[rand(0...journalists.length)] }.uniq

## this line tweet each @journalist of the random array
journalists_to_tweet.each { |chr|  rest_connection.update("Hello #{chr} #bonjour_monde @the_hacking_pro")}

## Favorite the last 25 tweets with the #bonjour_monde
rest_connection.search("#bonjour_monde", result_type: "recent").take(25).collect do |tweet|
  rest_connection.fav tweet
end

## Folow the last 20 people who tweeted with the #bonjour_monde hastag
rest_connection.search("#bonjour_monde", result_type: "recent").take(5).collect do |tweet|
  rest_connection.follow tweet.user
end

## Favorite and follow the posted tweet in real time with the #bonjour_monde
streaming_connection.filter(track: "#bonjour_monde") do |object|
  rest_connection.fav object # favorite the tweet
  rest_connection.follow object.user # follow the user who tweeted
end
