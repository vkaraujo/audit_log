# spec/audit_log/config_spec.rb
require "spec_helper"

RSpec.describe AuditLog do
  after { described_class.reset_configuration! }

  it "allows configuration of actor_method and ignored_attributes" do
    described_class.configure do |config|
      config.actor_method = :current_admin
      config.ignored_attributes = ["updated_at", "synced_at"]
    end

    expect(described_class.configuration.actor_method).to eq(:current_admin)
    expect(described_class.configuration.ignored_attributes).to eq(["updated_at", "synced_at"])
  end

  it "has sensible default values" do
    expect(described_class.configuration.actor_method).to eq(:current_user)
    expect(described_class.configuration.ignored_attributes).to eq(["updated_at"])
  end
end
