class StageAchievement < ActiveRecord::Base
  attr_accessible :kind,
                  :title,
                  :stage_id,
                  :scan

  belongs_to :stage

  validates_presence_of :stage_id, :title, :kind
  has_attached_file :scan, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }
end
