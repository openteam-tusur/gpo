class ParticipantStudentAchievement < ActiveRecord::Base
  attr_accessible :participant_id, :student_achievement_id
  belongs_to :participant
  belongs_to :student_achievement

end
