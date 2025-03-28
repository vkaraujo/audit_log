# lib/audit_log/helpers.rb
module AuditLog
  module Helpers
    # Executes a block with the given audit context
    #
    # Example:
    #   AuditLog.with_context(actor: current_user, reason: "Batch update") do
    #     user.update!(name: "New")
    #   end
    #
    def self.with_context(actor: nil, reason: nil)
      AuditLog::Context.actor = actor
      AuditLog::Context.reason = reason
      yield
    ensure
      AuditLog::Context.reset!
    end
  end
end
