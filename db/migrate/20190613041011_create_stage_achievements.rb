class CreateStageAchievements < ActiveRecord::Migration
  def change
    create_table :stage_achievements do |t|
      t.text :grant
      t.text :publication
      t.text :exhibition
      t.text :diploma
      t.references :stage, index: true

      t.timestamps
    end
  end
end
