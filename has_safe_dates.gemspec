# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_safe_dates/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name                  = "has_safe_dates"
  s.version               = HasSafeDates::VERSION
  s.authors               = ["kylejginavan"]
  s.date                  = "2012-02-24"
  s.description           = "Uses Chronic to parse incoming dates and does not raise errors on invalid multi parameter settings"
  s.email                 = "kylejginavan@gmail.com"
  s.required_ruby_version = ">= 3.4"

  s.extra_rdoc_files      = ["MIT-LICENSE.txt", "README.md"]
  s.files                 = `git ls-files`.split("\n")
  s.homepage              = "http://github.com/kylejginavan/has_safe_dates"
  s.require_paths         = ["lib"]
  s.test_files            = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables           = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.summary               = "Chronic based date setting for ActiveRecord models"
  s.licenses              = ["HQ"]

  s.add_dependency "chronic",                                    "~> 0.10"

  s.add_development_dependency "activerecord",                   "~> 7.2"
  s.add_development_dependency "database_cleaner",               "~> 2.1"
  s.add_development_dependency "rdoc",                           "~> 7.0"
  s.add_development_dependency "rspec",                          "~> 3.13"
  s.add_development_dependency "rspec_junit_formatter",          "~> 0.6", ">= 0.3.0"
end
