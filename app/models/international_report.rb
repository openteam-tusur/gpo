class InternationalReport < ActiveRecord::Base
  attr_accessible :description,
                  :stage_id,
                  :participant_id

  belongs_to :participant
  belongs_to :stage
  delegate :chair, :to => :stage

  validates_presence_of :stage_id, :participant_id
end
