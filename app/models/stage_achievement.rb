class StageAchievement < ActiveRecord::Base
  attr_accessible :kind,
                  :title,
                  :stage_id

  belongs_to :stage

  validates_presence_of :stage_id
  has_attached_file :attachment
end
