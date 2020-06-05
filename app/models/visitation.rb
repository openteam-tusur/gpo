class Visitation < ActiveRecord::Base
  acts_as_paranoid

  attr_accessible :gpoday_id

  belongs_to :gpoday
  belongs_to :participant

  validates_presence_of :gpoday_id, :participant_id
  validates_uniqueness_of :gpoday_id, :scope => :participant_id
  validates_numericality_of :rate, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2, :on => :update

  scope :beetween_dates, ->(from,to) { joins(:gpoday).where("gpodays.date between :from and :to", :from => from, :to => to) }

  scope :for_participant, ->(participant) { where(:participant_id => participant) }

  scope :ascending,  -> { joins(:gpoday).order("gpodays.date") }
  scope :descending, -> { joins(:gpoday).order("gpodays.date desc") }

  def kt_issues_sum
    Issue.for_participant(participant).beetween_dates(kt_start, date).sum(:grade)
  end

  def kt_sum
    Visitation.for_participant(participant).beetween_dates(kt_start, date).sum(:rate) +
      kt_issues_sum
  end

  def total_issues_sum
    Issue.sum(:grade, :conditions => ['participant_id = ? AND closed_at >= ?', participant.id, Gpoday.find(:first, :order => "date").date])
  end

  def total_sum
    Visitation.for_participant(participant).sum(:rate, :joins => :gpoday, :conditions => ["gpodays.date <= ?", date]) +
      total_issues_sum.to_f
  end

  def kt?
    gpoday.kt?
  end

  def date
    gpoday.date
  end

  private

  def kt_start
    prev_kt = Gpoday.descending.find(:first, :conditions => ["gpodays.date < ? and kt = ?", date, true])
    prev_kt ? Gpoday.ascending.find(:first, :conditions => ["gpodays.date > ?", prev_kt.date]).date : Gpoday.ascending.first.date
  end
end

# == Schema Information
#
# Table name: visitations
#
#  id             :integer          not null, primary key
#  participant_id :integer
#  gpoday_id      :integer
#  rate           :float
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
