class AddDistanceLearningToIssues < ActiveRecord::Migration
  def change
    add_column :issues, :distance_learning, :boolean, default: false
  end
end
