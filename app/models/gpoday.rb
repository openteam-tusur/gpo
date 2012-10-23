# encoding: utf-8
class Gpoday < ActiveRecord::Base

  validates_presence_of :date
  has_many :visitations, :dependent => :destroy

  scope :ascending, order("date asc")
  scope :descending, order("date desc")
end

