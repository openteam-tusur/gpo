class Visitation < ActiveRecord::Base
  belongs_to :gpoday
  belongs_to :participant
  validates_presence_of :gpoday_id, :participant_id
  validates_uniqueness_of :gpoday_id, :scope => :participant_id
  validates_numericality_of :rate, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2, :on => :update
end

