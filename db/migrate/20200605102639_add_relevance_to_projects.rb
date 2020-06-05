class AddRelevanceToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :relevance, :text
  end
end
