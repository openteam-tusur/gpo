# encoding: utf-8

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
#  created_at         :datetime
#  updated_at         :datetime
#

class Issue < ActiveRecord::Base
  validates_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  validates_presence_of :grade, :if => :closed_at
  validates_presence_of :closed_at, :if => :grade
  validates_presence_of :results, :if => Proc.new { |issue| issue.closed_at || issue.grade }
  belongs_to :participant

  scope :for_participant, ->(participant) { where(:participant_id => participant) }

  scope :beetween_dates, ->(from,to) { where "closed_at between :from and :to", :from => from, :to => to }

end
