class Issue < ActiveRecord::Base
  attr_accessible :name, :description, :planned_closing_at, :planned_grade, :closed_at, :grade, :results

  belongs_to :participant
  has_one :project, :through => :participant

  scope :for_participant, ->(participant) { where(:participant_id => participant) }
  scope :beetween_dates, ->(from,to) { where "closed_at between :from and :to", :from => from, :to => to }

  validates_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  validates_presence_of :grade, :if => :closed_at
  validates_presence_of :closed_at, :if => :grade
  validates_presence_of :results, :if => Proc.new { |issue| issue.closed_at || issue.grade }

end

# == Schema Information
#
# Table name: issues
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  description        :text
#  planned_closing_at :date
#  planned_grade      :integer
#  closed_at          :date
#  grade              :integer
#  results            :text
#  participant_id     :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
