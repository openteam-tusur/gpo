class StageAchievement < ActiveRecord::Base
  attr_accessible :grant,
                  :publication,
                  :exhibition,
                  :diploma,
                  :stage_id

  belongs_to :stage

  validates_presence_of :stage_id
end
