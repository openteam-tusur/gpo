class Visitation < ActiveRecord::Base

  belongs_to :gpoday
  belongs_to :participant
  validates_presence_of :gpoday_id, :participant_id
  validates_uniqueness_of :gpoday_id, :scope => :participant_id
  validates_numericality_of :rate, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2, :on => :update

  named_scope :beetween_dates, lambda { |from, to|
    {
      :joins => :gpoday,
      :conditions => ["gpodays.date between :from and :to", {:from => from, :to => to}]
    }
  }

  named_scope :for_participant, lambda { |participant|
    {
      :conditions => {:participant_id => participant.id}
    }
  }

  named_scope :ascending, :joins => :gpoday, :order => "gpodays.date"
  named_scope :descending, :joins => :gpoday, :order => "gpodays.date desc"

  def sum
    Visitation.for_participant(participant).beetween_dates(kt_start, date).sum(:rate)
  end

  def total
    Visitation.for_participant(participant).sum(:rate, :joins => :gpoday, :conditions => ["gpodays.date <= ?", date])
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
