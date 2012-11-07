class RenameRulesToPermissions < ActiveRecord::Migration
  def change
    rename_table :rules, :permissions
    Permission.where(:context_id => nil).
      update_all(:context_id => (Context.first || Context.create), :context_type => 'Context')
    Permission.where(:context_type => Project).where('id not in (select id from projects)').delete_all
    add_index :permissions, [:user_id, :role, :context_id, :context_type], :name => 'by_user_and_role_and_context'
  end
end
