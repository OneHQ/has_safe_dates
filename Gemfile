# frozen_string_literal: true

source "https://rubygems.org"

gem "base64"
gem "benchmark"
gem "bigdecimal"
gem "byebug"
gem "logger"
gem "mutex_m"
gem "ostruct"
gem "pkg-config"
gem "sqlite3",                      "~> 2.1"

gemspec

# Verify both supported Rails series during the upgrade.
def next?
  File.basename(__FILE__) == "Gemfile.next"
end

gem "next_rails"
gem "activerecord", next? ? "= 8.1.3.1" : "= 8.0.5.1"
