# frozen_string_literal: true

require "logger"
require "active_support"
require "active_record"
require "database_cleaner"
require "yaml"

ENV["debug"] = "test" unless ENV["debug"]

config_path = File.join(__dir__, "db", "database.yml")
config = YAML.load_file(config_path)

db_key = ENV["DB"] || "sqlite3"
db_config = config.fetch(db_key)

ActiveRecord::Base.establish_connection(db_config)

load File.join(__dir__, "db", "schema.rb")

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "has_safe_dates"

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each)  { DatabaseCleaner.clean }
end
