class ChangeTypeOfTitleToTextInStudentAchievements < ActiveRecord::Migration
  def up
    change_column :student_achievements, :title, :text
  end

  def down
    change_column :student_achievements, :title, :string
  end
end
