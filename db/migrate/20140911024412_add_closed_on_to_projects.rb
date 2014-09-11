class AddClosedOnToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :closed_on, :date
  end
end
