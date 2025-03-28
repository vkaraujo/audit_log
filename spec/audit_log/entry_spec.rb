# spec/audit_log/entry_spec.rb
require "spec_helper"

RSpec.describe AuditLog::Entry do
  it "has a valid factory or can be created manually" do
    entry = described_class.new(
      auditable_type: "Post",
      auditable_id: 1,
      action: "update",
      changed_data: { "title" => ["Old", "New"] }
    )

    expect(entry).to be_valid
  end

  it "is invalid without an action" do
    entry = described_class.new(
      auditable_type: "Post",
      auditable_id: 1,
      changed_data: { "title" => ["Old", "New"] }
    )

    expect(entry).not_to be_valid
    expect(entry.errors[:action]).to include("can't be blank")
  end
end
