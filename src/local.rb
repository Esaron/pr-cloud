#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source "https://rubygems.org"
  gem "magic_cloud"
  gem 'pry'
  gem 'pry-byebug'
end

puts 'Dependencies installed'

USER = ENV['GIT_USER']
COMMON_WORDS = %w[
  the of and a to in is you that it he was for on are as with his they i at be this have from or one had by word but not what all were we when your can said there use an each which she do how their if will up other about out many then them these so some her would make like him into has two more write go see number no way could people my than first been call who its now did made
].freeze

# Don't be dumb with env variables; I'm not bothering to make this work well.
commits = `git --no-pager log --all --pretty=oneline --author "#{USER}"` 
pr_word_counts = commits.split&.map(&:downcase)&.tally&.except(*COMMON_WORDS)
words = pr_word_counts.each_with_object({}) do |(word, count), memo|
  memo[word] = (memo[word] || 0) + count
end.sort { |a, b| b[1] <=> a[1] }.to_a.first(50)
cloud = MagicCloud::Cloud.new(words, rotate: :free, scale: :log)
img = cloud.draw(1280, 720)
img.write('cloud.png')
