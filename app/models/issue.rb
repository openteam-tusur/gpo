class Issue < ActiveRecord::Base
  attr_accessible :name,
    :description,
    :planned_closing_at,
    :planned_grade,
    :closed_at,
    :grade,
    :results,
    :archived,
    :distance_learning

  belongs_to :participant
  has_one :project, through: :participant
  has_many :issue_attachments, dependent: :destroy

  scope :for_participant, ->(participant) { where(participant_id: participant) }
  scope :beetween_dates, ->(from,to) { where "closed_at between :from and :to", from: from, to: to }
  scope :order_by_closed_at, -> { reorder(closed_at: :desc) }
  scope :distance,        -> { where(:distance_learning => :true) }
  scope :local,        -> { where(:distance_learning => :false) }
  scope :archived, -> { where(archived: true) }
  scope :not_archived, -> { where(archived: false) }

  validates_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  validates_presence_of :grade, if: :closed_at
  validates_presence_of :closed_at, if: :grade
  validates_presence_of :results, if: Proc.new { |issue| issue.closed_at || issue.grade }

  default_value_for :archived, false
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
#  archived           :boolean
#
