class AddPurposeAndSourseDataToProject < ActiveRecord::Migration
  def self.up
    add_column :projects, :goal, :text
    add_column :projects, :source_data, :text
  end

  def self.down
    remove_column :projects, :source_data
    remove_column :projects, :goal
  end
end
