#!/usr/bin/env ruby
# grammarbot!

require 'discordrb'
require_relative 'grammar/grammar'

config = File.foreach('config.txt').map { |line| line.split(' ').join(' ') }
token = config[0].to_s
client_id = config[1].to_s
client = Discordrb::Commands::CommandBot.new token: token, client_id: client_id, prefix: 'g!'

responses = {"you're" => ["*you're", "***you're*** wrong"], "your" => ["***your*** grammar is wrong", "*your"]}

client.message do |msg|
	if(msg.from_bot?)
		next
	end
	res = correct_message(msg.content.downcase)
	msg.message.reply!(responses[res[0].correct].sample, mention_user: true) if res
end

client.command :ping do |msg|
	msg.reply "Pong!"
end

at_exit { client.stop }
client.run
