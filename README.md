# AuditLog

A lightweight, Rails-friendly audit logging gem to track model changes (`create`, `update`, `destroy`) with contextual metadata like `actor` and `reason`. Perfect for admin panels, SaaS apps, and audit trails.

---

## ✨ Features

- Track `create`, `update`, and `destroy` events on any model  
- Store changes in an `audit_log_entries` table  
- Associate logs with the user (or any actor) who made the change  
- Optional `reason` for change  
- Configurable `only:` and `except:` fields  
- Easy to install and integrate

---

## 🔧 Installation

Add this line to your application's Gemfile:

```ruby
gem "audit_log", path: "path/to/your/local/gem" 
# or gem "audit_log" if published
```
Then run:
```ruby
bundle install
```
Install the initializer and migration:
```ruby
bin/rails generate audit_log:install
bin/rails db:migrate
```

## 🚀 Usage

### 1. Include the concern in your model:

```ruby
class Post < ApplicationRecord
  include AuditLog::Model

  audited
end
```
You can optionally limit or exclude tracked attributes:
```ruby
audited only: [:title, :status]         # Only track these fields
audited except: [:updated_at, :synced]  # Track everything but these
```

### 2. Set the actor (who made the change):
In your controller (e.g. ApplicationController):
```ruby
before_action do
  AuditLog::Context.actor = current_user
end
```
You can configure the method name (current_user) in the initializer.

### 3. Optionally set a reason:
You can set a reason for changes anywhere in your code:
```ruby
AuditLog::Context.with(reason: "bulk import") do
  post.update!(status: "archived")
end
```

## ⚙️ Configuration
Generated initializer at config/initializers/audit_log.rb:
```ruby
AuditLog.configure do |config|
  config.actor_method = :current_user
  config.ignored_attributes = ["updated_at"]
end
```

## 🧪 Testing in your app
Use AuditLog::Entry to inspect audit logs:
```ruby
AuditLog::Entry.for_model(post).order(created_at: :desc)
```

## 📦 Entry Table Schema
The install generator includes a migration that creates:
```ruby
create_table :audit_log_entries do |t|
  t.string  :auditable_type
  t.bigint  :auditable_id
  t.string  :action
  t.json    :changed_data
  t.string  :reason
  t.string  :actor_type
  t.bigint  :actor_id
  t.timestamps
end
```

## ✅ Development
This gem uses rspec and an in-memory SQLite DB to test audit hooks.

Run specs with:
```ruby
bundle exec rspec
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/audit_log. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/audit_log/blob/master/CODE_OF_CONDUCT.md).

## 📄 License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## 🙌 Credits

Created with by Viktor Araújo.

Inspired by open-source audit trail gems like PaperTrail, Audited, and others — but lighter and more simple.
