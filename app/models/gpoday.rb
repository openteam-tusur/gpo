# encoding: utf-8

# == Schema Information
#
# Table name: gpodays
#
#  id         :integer          not null, primary key
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#  kt         :boolean          default(FALSE)
#

class Gpoday < ActiveRecord::Base

  validates_presence_of :date
  has_many :visitations, :dependent => :destroy

  scope :ascending, order("date asc")
  scope :descending, order("date desc")
end

