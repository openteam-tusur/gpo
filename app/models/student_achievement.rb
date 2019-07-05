class StudentAchievement < ActiveRecord::Base
  attr_accessible :title,
                  :kind,
                  :stage_id,
                  :participant_id,
                  :scan

  belongs_to :participant
  belongs_to :stage

  validates_presence_of :stage_id, :participant_id, :title, :kind

  has_attached_file :scan, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }
end
