# frozen_string_literal: true

require "spec_helper"

RSpec.describe AuditLog::Helpers do
  let(:user) { double("User", id: 1, class: double(name: "User")) }

  it "sets actor and reason inside the block" do
    AuditLog::Helpers.with_context(actor: user, reason: "Doing something") do
      expect(AuditLog::Context.actor).to eq(user)
      expect(AuditLog::Context.reason).to eq("Doing something")
    end
  end

  it "resets actor and reason after the block" do
    AuditLog::Helpers.with_context(actor: user, reason: "Temporary action") do
      expect(AuditLog::Context.actor).to eq(user)
      expect(AuditLog::Context.reason).to eq("Temporary action")
    end

    expect(AuditLog::Context.actor).to be_nil
    expect(AuditLog::Context.reason).to be_nil
  end

  it "does not raise if no actor or reason is provided" do
    expect {
      AuditLog::Helpers.with_context {}
    }.not_to raise_error
  end
end
