class StageAchievement < ActiveRecord::Base
  attr_accessible :grant,
                  :publication,
                  :exhibition,
                  :diploma,
                  :stage_id

  belongs_to :stage
end
