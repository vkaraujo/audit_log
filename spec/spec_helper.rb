# frozen_string_literal: true

require "audit_log"
require "active_record"

# Establish in-memory SQLite database connection for testing
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

AuditLog.configure do |config|
  config.actor_method = :current_user
  config.ignored_attributes = ["updated_at"]
end
