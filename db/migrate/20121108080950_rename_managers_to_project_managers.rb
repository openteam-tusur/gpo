class RenameManagersToProjectManagers < ActiveRecord::Migration
  def change
    rename_table :managers, :project_managers
    Permission.where(:role => 'manager').update_all(:role => 'project_manager')
  end
end
