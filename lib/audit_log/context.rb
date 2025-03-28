# lib/audit_log/context.rb
module AuditLog
  class Context
    THREAD_KEY = :audit_log_context

    class << self
      # Set the current actor (e.g. current_user)
      def actor=(value)
        context[:actor] = value
      end

      def actor
        context[:actor]
      end

      # Set a reason for this audit action
      def reason=(value)
        context[:reason] = value
      end

      def reason
        context[:reason]
      end

      # Clears the stored context after each request/job
      def reset!
        Thread.current[THREAD_KEY] = {}
      end

      private

      # Lazily initializes the thread-local context hash
      def context
        Thread.current[THREAD_KEY] ||= {}
      end
    end
  end
end
