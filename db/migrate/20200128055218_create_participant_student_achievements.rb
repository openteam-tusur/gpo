class CreateParticipantStudentAchievements < ActiveRecord::Migration
  def change
    create_table :participant_student_achievements do |t|
      t.belongs_to :participant
      t.belongs_to :student_achievement
      t.timestamps
    end
  end
end
