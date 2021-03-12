class AddFromChairToProjectManager < ActiveRecord::Migration
  def change
    add_column :project_managers, :from_chair, :boolean, :default => false
  end
end
