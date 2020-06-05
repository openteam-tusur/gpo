class AddPracticalSignificanceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :practical_significance, :text
  end
end
