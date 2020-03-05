class ParticipantStudentAchievement < ActiveRecord::Base
  attr_accessible :participant_id, :student_achievement_id
  belongs_to :participant
  belongs_to :student_achievement

end

# == Schema Information
#
# Table name: participant_student_achievements
#
#  id                     :integer          not null, primary key
#  participant_id         :integer
#  student_achievement_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#
