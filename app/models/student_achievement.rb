class StudentAchievement < ActiveRecord::Base
  attr_accessible :title,
                  :kind,
                  :stage_id,
                  :scan

  has_many :participant_student_achievements
  has_many :participants, through: :participant_student_achievements, dependent: :destroy
  belongs_to :stage

  validates_presence_of :stage_id, :title, :kind

  validate :has_participants

  has_attached_file :scan, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }

  def has_participants
    unless participants.size > 0
      errors.add(:participants, "Не указаны участники")
    end
  end
end
