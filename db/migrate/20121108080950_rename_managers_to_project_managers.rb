class RenameManagersToProjectManagers < ActiveRecord::Migration
  def change
    rename_table :managers, :project_managers
    Permission.where(:role => 'manager').update_all(:role => :project_manager)
    Permission.where(:role => %w[admin supervisor]).update_all(:role => :manager)
    User.find_by_id(1).try :update_attribute, :email, 'mail@openteam.ru'
  end
end
