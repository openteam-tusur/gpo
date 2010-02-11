class Issue < ActiveRecord::Base
  validates_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  validates_presence_of :grade, :if => :closed_at
  validates_presence_of :closed_at, :if => :grade
  validates_presence_of :results, :if => Proc.new { |issue| issue.closed_at || issue.grade }
  belongs_to :participant
end
