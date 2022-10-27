#!/usr/bin/env ruby

OWNER_REPO, OWNER, REPO = ARGV.first&.match(/([\w_.-]+)\/([\w_.-]+)/).to_a
raise 'Expected exactly one argument of the format [GitHub owner]/[GitHub repo]' unless OWNER_REPO

require 'bundler/inline'

gemfile do
  source "https://rubygems.org"
  gem "octokit", "~> 5.0"
  gem "magic_cloud"
  gem 'pry'
  gem 'pry-byebug'
end

puts 'Dependencies installed'

TOKEN = ENV['GH_ACCESS_TOKEN']
USER = ENV['GH_USER']
CLIENT = Octokit::Client.new(access_token: TOKEN, per_page: 100)

pr_word_counts = CLIENT.search_issues("org:#{OWNER} repo:#{REPO} state:closed author:#{USER} type:pr").items.map { |pr| pr.title&.split&.tally }.compact
words = pr_word_counts.each_with_object({}) do |pr_word_count, memo|
  pr_word_count.each { |word, count| memo[word] = (memo[word] || 0) + count }
end.sort { |a, b| b[1] <=> a[1] }.to_a.first(50)
cloud = MagicCloud::Cloud.new(words, rotate: :free)
img = cloud.draw(1280, 720)
img.write('cloud.png')
