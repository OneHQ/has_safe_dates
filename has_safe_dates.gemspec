$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "has_safe_dates/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "has_safe_dates"
  s.version     = HasSafeDates::VERSION
  s.authors     = ["kylejginavan"]
  s.date        = %q{2012-02-24}
  s.description = %q{Uses Chronic to parse incoming dates and does not raise errors on invalid multi parameter settings}
  s.email       = %q{kylejginavan@gmail.com}

  s.extra_rdoc_files = [
    "MIT-LICENSE.txt",
    "README.md"
  ]
  s.files = [
    "Gemfile",
    "Rakefile",
    "MIT-LICENSE.txt",
    "README.md",
    "Rakefile",
    "has_safe_dates.gemspec",
    "lib/has_safe_dates/core_ext.rb",
    "lib/has_safe_dates/version.rb",
    "lib/has_safe_dates.rb",
    "spec/db/database.yml",
    "spec/db/schema.rb",
    "spec/has_safe_dates_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/kylejginavan/has_safe_dates}
  s.require_paths = ["lib"]
  s.summary = %q{Chronic based date setting for ActiveRecord models}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency("activerecord", ['~> 4.0.0'])
      s.add_dependency("chronic")
      s.add_development_dependency("rspec", [">= 0", "< 3"])
      s.add_development_dependency("rdoc", ["~> 3.12"])
      s.add_development_dependency("bundler", ["~> 1.0"])
      s.add_development_dependency("sqlite3")
      s.add_development_dependency('database_cleaner')
      s.add_development_dependency('debugger')
    else
      s.add_dependency("activerecord", ['>= 3.1.0'])
      s.add_dependency("chronic")
      s.add_dependency("rspec", [">= 0"])
      s.add_dependency("rdoc", ["~> 3.12"])
      s.add_dependency("bundler", ["~> 1.0.0"])
    end
  else
    s.add_dependency('activerecord', ['>= 3.1.0'])
    s.add_dependency('chronic')
    s.add_dependency("rspec", [">= 0"])
    s.add_dependency("rdoc", ["~> 3.12"])
    s.add_dependency("bundler", ["~> 1.0.0"])
  end
end
