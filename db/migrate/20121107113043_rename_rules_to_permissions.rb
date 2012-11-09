class RenameRulesToPermissions < ActiveRecord::Migration
  def change
    rename_table :rules, :permissions
    Permission.where(:context_id => nil).
      update_all(:context_id => (Context.first || Context.create), :context_type => 'Context')
    Permission.where(:context_type => 'Project').where('context_id not in (select id from projects)').delete_all
    Permission.where(:created_at => nil).update_all(:created_at => DateTime.parse('2009-01-28 10:35:55'))
    Permission.where(:updated_at => nil).update_all('updated_at = created_at')
    add_index :permissions, [:user_id, :role, :context_id, :context_type], :name => 'by_user_and_role_and_context'
  end
end
