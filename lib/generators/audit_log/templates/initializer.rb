# frozen_string_literal: true

# Configure AuditLog defaults
AuditLog.configure do |config|
  # Method used to get the actor (e.g. :current_user or :current_admin)
  config.actor_method = :current_user

  # Attributes to ignore when tracking changes
  config.ignored_attributes = ["updated_at"]
end
