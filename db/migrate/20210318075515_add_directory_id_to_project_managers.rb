class AddDirectoryIdToProjectManagers < ActiveRecord::Migration
  def change
    add_column :project_managers, :directory_id, :integer
  end
end
