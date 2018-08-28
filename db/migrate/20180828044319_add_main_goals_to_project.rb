class AddMainGoalsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :main_goals, :text
  end
end
