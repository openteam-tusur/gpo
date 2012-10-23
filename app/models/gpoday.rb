class Gpoday < ActiveRecord::Base

  validates_presence_of :date
  has_many :visitations, :dependent => :destroy

  named_scope :ascending, :order => "date asc"
  named_scope :descending, :order => "date desc"


end

