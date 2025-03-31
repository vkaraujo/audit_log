# frozen_string_literal: true

require_relative "lib/audit_log/version"

Gem::Specification.new do |spec|
  spec.name = "audit_log"
  spec.version = AuditLog::VERSION
  spec.authors = ["viktor"]
  spec.email = ["araujo"]

  spec.summary     = "Track changes to models with audit logging."
  spec.description = "AuditLog is a lightweight gem for adding create/update/delete auditing to your Rails models. Tracks changes, actor, and optional reasons."
  spec.homepage    = "https://github.com/vkaraujo/audit_log"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata["homepage_uri"] = "https://github.com/vkaraujo/audit_log"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency "rails", ">= 6.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
