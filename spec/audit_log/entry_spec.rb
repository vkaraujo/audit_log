# frozen_string_literal: true

require "spec_helper"

RSpec.describe AuditLog::Entry do
  before do
    ActiveRecord::Schema.define do
      suppress_messages do
        create_table :audit_log_entries, force: true do |t|
          t.string :auditable_type
          t.bigint :auditable_id
          t.string :action
          t.json :changed_data
          t.string :reason
          t.string :actor_type
          t.bigint :actor_id
          t.timestamps
        end
      end
    end
  end

  it "has a valid factory or can be created manually" do
    entry = described_class.new(
      auditable_type: "Post",
      auditable_id: 1,
      action: "update",
      changed_data: { "title" => %w[Old New] }
    )

    expect(entry).to be_valid
  end

  it "is invalid without an action" do
    entry = described_class.new(
      auditable_type: "Post",
      auditable_id: 1,
      changed_data: { "title" => %w[Old New] }
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:action]).to include("can't be blank")
  end
end
