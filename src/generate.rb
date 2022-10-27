#!/usr/bin/env ruby

match, owner, repo = ARGV.first&.match(/([\w_-]+)\/([\w_-]+)/).to_a
raise 'Expected exactly one argument of the format [GitHub owner]/[GitHub repo]' unless match

require 'bundler/inline'

gemfile do
  source "https://rubygems.org"
  gem "octokit", "~> 5.0"
  gem "magic_cloud"
  gem 'pry'
  gem 'pry-byebug'
end

puts 'Dependencies installed'

client = Octokit::Client.new(access_token: ENV['GH_ACCESS_TOKEN'])
binding.pry
client.pull_requests(match)

