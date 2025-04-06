# frozen_string_literal: true

module AuditLog
  module Helpers
    # Sets temporary audit context (actor and reason) for the duration of the block.
    #
    # Example:
    #   AuditLog::Helpers.with_context(actor: current_user, reason: "Batch update") do
    #     user.update!(name: "New")
    #   end

    def self.with_context(actor: nil, reason: nil)
      AuditLog::Context.actor = actor
      AuditLog::Context.reason = reason
      yield
    ensure
      AuditLog::Context.reset!
    end
  end
end
