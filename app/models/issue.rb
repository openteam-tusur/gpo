# encoding: utf-8
class Issue < ActiveRecord::Base
  validates_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  validates_presence_of :grade, :if => :closed_at
  validates_presence_of :closed_at, :if => :grade
  validates_presence_of :results, :if => Proc.new { |issue| issue.closed_at || issue.grade }
  belongs_to :participant

  scope :for_participant, ->(participant) { where(:participant_id => participant) }

  scope :beetween_dates, ->(from,to) { where "closed_at between :from and :to", :from => from, :to => to }

end
