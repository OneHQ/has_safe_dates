# encoding: utf-8

require 'rubygems'
require 'rake'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

task :spec do
  sh("bundle exec rspec spec") { |ok, res| }
end

task :default => :spec
