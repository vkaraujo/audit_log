# frozen_string_literal: true

require "spec_helper"

RSpec.describe AuditLog::Context do
  let(:user) { double("User", id: 1, class: double(name: "User")) }

  after { described_class.reset! }

  it "stores and retrieves actor" do
    described_class.actor = user
    expect(described_class.actor).to eq(user)
  end

  it "stores and retrieves reason" do
    described_class.reason = "Mass update"
    expect(described_class.reason).to eq("Mass update")
  end

  it "resets both actor and reason" do
    described_class.actor = user
    described_class.reason = "Just because"
    described_class.reset!

    expect(described_class.actor).to be_nil
    expect(described_class.reason).to be_nil
  end
end
