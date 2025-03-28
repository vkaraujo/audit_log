# lib/audit_log/model.rb
require "active_support/concern"

module AuditLog
  module Model
    extend ActiveSupport::Concern

    included do
      # Stores configuration options passed to the `audited` macro
      class_attribute :audit_log_options
    end

    class_methods do
      # Call this in any model to enable audit logging
      # Example: `audited only: [:name], except: [:updated_at]`
      def audited(only: nil, except: [])
        self.audit_log_options = {
          only: Array(only).map(&:to_s),
          except: Array(except).map(&:to_s)
        }

        # Includes the callback hooks that handle logging
        include AuditLog::Model::Hooks
      end
    end

    module Hooks
      extend ActiveSupport::Concern

      included do
        # Add model lifecycle callbacks for auditing
        after_create  :log_audit_create
        before_update :log_audit_update
        before_destroy :log_audit_destroy
      end

      private

      # Called after a record is created
      # Logs all initial attributes
      def log_audit_create
        create_audit_entry("create", changes_to_save)
      end

      # Called before a record is updated
      # Skips logging if there are no meaningful changes
      def log_audit_update
        return if saved_changes.except(*ignored_audit_attrs).empty?

        create_audit_entry("update", saved_changes.except(*ignored_audit_attrs))
      end

      # Called before a record is destroyed
      # Logs the full record state before deletion
      def log_audit_destroy
        create_audit_entry("destroy", attributes)
      end

      # Actually creates the audit log entry
      def create_audit_entry(action, changed_data)
        AuditLog::Entry.create!(
          auditable: self,
          action: action,
          actor: AuditLog::Context.actor,
          reason: AuditLog::Context.reason,
          changed_data: changed_data
        )
      end

      # Builds the list of attributes to ignore when logging
      def ignored_audit_attrs
        ["updated_at"] + Array(audit_log_options[:except])
      end
    end
  end
end
