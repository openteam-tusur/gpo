class AddTargetAudienceToProject < ActiveRecord::Migration
  def change
    add_column :projects, :target_audience, :text
  end
end
