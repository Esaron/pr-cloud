#!/usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source "https://rubygems.org"
  gem "octokit", "~> 5.0"
  gem "magic_cloud"
end

puts 'Dependencies installed'
