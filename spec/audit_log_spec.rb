# frozen_string_literal: true

RSpec.describe AuditLog do
  it "has a version number" do
    expect(AuditLog::VERSION).not_to be nil
  end

  it "is configurable" do
    expect { AuditLog.configure {} }.not_to raise_error
  end
end
