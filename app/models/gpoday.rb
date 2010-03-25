class Gpoday < ActiveRecord::Base

  validates_presence_of :date
  has_many :visitations, :dependent => :destroy
  default_scope :order => :date

end

