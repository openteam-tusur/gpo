class Visitation < ActiveRecord::Base

  belongs_to :gpoday
  belongs_to :participant
  validates_presence_of :gpoday_id, :participant_id
  validates_uniqueness_of :gpoday_id, :scope => :participant_id
  validates_numericality_of :rate, :allow_nil => true, :greater_than_or_equal_to => 0, :less_than_or_equal_to => 2, :on => :update

  def kt?
    gpoday.kt?
  end

  def date
    gpoday.date
  end

  def prev
    Visitation.find(:last, :joins => :gpoday, :order => "gpodays.date", :conditions => ["gpodays.date < ?", date])
  end

  def prev_kt
    Visitation.find(:last, :joins => :gpoday, :order => "gpodays.date", :conditions => ["gpodays.date < ? and kt = ?", date, true])
  end

  def self.first
    Visitation.find(:first, :joins => :gpoday, :order => "gpodays.date")
  end

  def next
    Visitation.find(:first, :joins => :gpoday, :order => "gpodays.date", :conditions => ["gpodays.date > ?", date])
  end

  def summ
    kt_start = prev_kt
    unless kt_start.nil?
      kt_start = kt_start.next
    else
      kt_start = Visitation.first
    end
    Visitation.sum(:rate, :joins => :gpoday,
      :conditions => ["gpodays.date between :begin and :end", {:begin => kt_start.gpoday.date, :end => date}])
  end

  def total
    Visitation.sum(:rate, :joins => :gpoday, :conditions => ["gpodays.date < ?", date]) + rate
  end

end
