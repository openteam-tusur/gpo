class ChangeUser < ActiveRecord::Migration
  def change
    rename_table  :users,  :people
    add_column    :people, :user_id, :string
    remove_column :people, :current_sign_in_at
    remove_column :people, :current_sign_in_ip
    remove_column :people, :last_sign_in_at
    remove_column :people, :last_sign_in_ip
    remove_column :people, :sign_in_count
    rename_column :project_managers, :user_id, :person_id
  end
end
