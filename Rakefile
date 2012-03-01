# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "has_safe_dates"
  gem.homepage = "http://github.com/kylejginavan/has_safe_dates"
  gem.license = "MIT"
  gem.summary = %Q{The easy way to add safe dates to any Rails model.}
  gem.description = %Q{Uses Chronic to parse incoming dates and does not raise errors on invalid multi parameter settings.}
  gem.email = "kylejginavan@gmail.com"
  gem.homepage = "http://github.com/kylejginavan/has_safe_dates"
  gem.authors = ["kylejginavan"]
end
Jeweler::RubygemsDotOrgTasks.new

task :spec do
  sh("bundle exec rspec spec") { |ok, res| }
end

task :default => :spec

=begin

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "has_safe_dates"
    gem.summary = %Q{The easy way to add safe dates to any Rails model.}
    gem.description = %Q{Uses Chronic to parse incoming dates and does not raise errors on invalid multi parameter settings.}
    gem.email = "kylejginavan@gmail.com"
    gem.homepage = "http://github.com/kylejginavan/has_safe_dates"
    gem.add_dependency('builder')
    gem.authors = ["kylejginavan"]
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "has_safe_dates (or a dependency) not available. Install it with: gem install has_safe_dates"
end

begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

# begin
#   require 'rdoc/task'
# rescue LoadError
#   require 'rdoc/rdoc'
#   require 'rake/task'
#   RDoc::Task = Rake::RDocTask
# end
# 
# RDoc::Task.new(:rdoc) do |rdoc|
#   rdoc.rdoc_dir = 'rdoc'
#   rdoc.title    = 'SafeDates'
#   rdoc.options << '--line-numbers'
#   rdoc.rdoc_files.include('README.rdoc')
#   rdoc.rdoc_files.include('lib/**/*.rb')
# end

Bundler::GemHelper.install_tasks

task :spec do
  sh("bundle exec rspec spec") { |ok, res| }
end

task :default => :spec
=end