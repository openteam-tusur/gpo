class AddResultToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :result, :string
  end
end
