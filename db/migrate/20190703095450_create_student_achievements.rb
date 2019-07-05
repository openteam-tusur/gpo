class CreateStudentAchievements < ActiveRecord::Migration
  def change
    create_table :student_achievements do |t|
      t.string :kind
      t.string :title
      t.attachment :scan
      t.references :participant, index: true
      t.references :stage, index: true

      t.timestamps
    end
  end
end
