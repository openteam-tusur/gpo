class ChangeTypeOfTitleToTextInStageAchievements < ActiveRecord::Migration
  def up
    change_column :stage_achievements, :title, :text
  end

  def down
    change_column :stage_achievements, :title, :string
  end
end
