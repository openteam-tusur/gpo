class AttestationMark < ActiveRecord::Base
  attr_accessible :mark,
                  :stage_id,
                  :participant_id

  belongs_to :participant
  belongs_to :stage

  validates_presence_of :stage_id, :participant_id, :mark
  validates_inclusion_of :mark, :in => 0..30
  validates_uniqueness_of :participant_id, :scope => [:stage_id], :message => 'Баллы для участника уже выставлены'
end

# == Schema Information
#
# Table name: attestation_marks
#
#  id             :integer          not null, primary key
#  mark           :integer
#  participant_id :integer
#  stage_id       :integer
#  created_at     :datetime
#  updated_at     :datetime
#
