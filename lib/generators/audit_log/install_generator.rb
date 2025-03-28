# frozen_string_literal: true

require "rails/generators"

module AuditLog
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_initializer
        template "initializer.rb", "config/initializers/audit_log.rb"
      end
    end
  end
end
