# frozen_string_literal: true

require "spec_helper"

RSpec.describe AuditLog::Model do
  let(:actor) { User.create!(email: "test@example.com") }
  let(:audit_only) { nil }
  let(:audit_except) { [] }

  before do
    ActiveRecord::Schema.define do
      suppress_messages do
        create_table :test_models, force: true do |t|
          t.string :name
          t.string :status
          t.timestamps
        end

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

        create_table :users, force: true do |t|
          t.string :email
        end
      end
    end

    stub_const("User", Class.new(ActiveRecord::Base))
    AuditLog::Context.actor = actor
  end

  after { AuditLog::Context.reset! }

  def build_test_model(audited_options = {})
    stub_const("TestModel", Class.new(ActiveRecord::Base) do
      self.table_name = "test_models"
      include AuditLog::Model

      audited(**audited_options)

      attribute :name, :string
      attribute :status, :string
    end)
  end

  context "with default auditing" do
    before { build_test_model }

    it "creates an audit log on create" do
      expect {
        TestModel.create!(name: "Test")
      }.to change { AuditLog::Entry.count }.by(1)

      entry = AuditLog::Entry.last
      expect(entry.action).to eq("create")
      expect(entry.auditable_type).to eq("TestModel")
      expect(entry.changed_data).to include("name")
    end

    it "creates an audit log on update" do
      model = TestModel.create!(name: "Before").reload

      expect {
        model.update!(name: "After")
      }.to change { AuditLog::Entry.count }.by(1)

      entry = AuditLog::Entry.last
      expect(entry.action).to eq("update")
      expect(entry.changed_data["name"]).to eq(%w[Before After])
    end

    it "creates an audit log on destroy" do
      model = TestModel.create!(name: "To Be Deleted")

      expect {
        model.destroy
      }.to change { AuditLog::Entry.count }.by(1)

      entry = AuditLog::Entry.last
      expect(entry.action).to eq("destroy")
      expect(entry.changed_data).to include("name" => "To Be Deleted")
    end
  end

  context "when using only: option" do
    let(:audit_only) { [:status] }

    before { build_test_model(only: audit_only, except: []) }

    it "only logs changes to specified attributes" do
      model = TestModel.create!(name: "Original", status: "active").reload

      expect {
        model.update!(name: "New Name", status: "inactive")
      }.to change { AuditLog::Entry.count }.by(1)

      entry = AuditLog::Entry.last
      expect(entry.changed_data).to include("status" => %w[active inactive])
      expect(entry.changed_data).not_to include("name")
    end
  end

  context "when using except: option" do
    let(:audit_except) { [:status] }

    before { build_test_model(only: nil, except: audit_except) }

    it "excludes specified attributes from tracking" do
      model = TestModel.create!(name: "Name", status: "old").reload

      expect {
        model.update!(name: "Changed", status: "ignored")
      }.to change { AuditLog::Entry.count }.by(1)

      entry = AuditLog::Entry.last
      expect(entry.changed_data).to include("name" => %w[Name Changed])
      expect(entry.changed_data).not_to include("status")
    end
  end

  context "when no tracked fields change" do
    let(:audit_only) { [:name] }

    before { build_test_model(only: audit_only, except: []) }

    it "does not create an audit log entry" do
      model = TestModel.create!(name: "Keep", status: "unchanged").reload

      expect {
        model.update!(status: "changed")
      }.not_to change { AuditLog::Entry.count }
    end
  end
end
