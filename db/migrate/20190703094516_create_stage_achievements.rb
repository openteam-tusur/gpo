class CreateStageAchievements < ActiveRecord::Migration
  def change
    create_table :stage_achievements do |t|
      t.string :kind
      t.string :title
      t.attachment :file
      t.references :stage, index: true

      t.timestamps
    end
  end
end
