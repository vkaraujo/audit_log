# frozen_string_literal: true

require "rails/generators"

module AuditLog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer
        template "initializer.rb", "config/initializers/audit_log.rb"
      end

      def copy_migration
        timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        migration_name = "create_audit_log_entries"
        copy_file "migration.rb", "db/migrate/#{timestamp}_#{migration_name}.rb"
      end
    end
  end
end
