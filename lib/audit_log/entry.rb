# frozen_string_literal: true
require "active_record"

module AuditLog
  class Entry < ActiveRecord::Base
    self.table_name = "audit_log_entries"

    belongs_to :auditable, polymorphic: true
    belongs_to :actor, polymorphic: true, optional: true

    # serialize :changed_data, coder: JSON

    validates :action, presence: true
    validates :auditable_type, :auditable_id, presence: true

    scope :for_model, ->(model) do
      where(auditable_type: model.class.name, auditable_id: model.id)
    end
  end
end
