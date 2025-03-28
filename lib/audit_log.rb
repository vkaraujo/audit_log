# frozen_string_literal: true
require_relative "audit_log/version"
require_relative "audit_log/config"
require_relative "audit_log/context"
require_relative "audit_log/entry"
require_relative "audit_log/model"

module AuditLog
  class Error < StandardError; end
  # Your code goes here...
end
