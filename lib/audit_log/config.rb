# lib/audit_log/config.rb
module AuditLog
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end

    def reset_configuration!
      self.configuration = Configuration.new
    end
  end

  class Configuration
    attr_accessor :actor_method, :ignored_attributes

    def initialize
      @actor_method = :current_user
      @ignored_attributes = ["updated_at"]
    end
  end
end
