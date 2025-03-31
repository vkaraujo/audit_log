class CreateAuditLogEntries < ActiveRecord::Migration[6.0]
  def change
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

    add_index :audit_log_entries, [:auditable_type, :auditable_id]
    add_index :audit_log_entries, [:actor_type, :actor_id]
  end
end
