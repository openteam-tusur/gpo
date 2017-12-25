class Gpoday < ActiveRecord::Base
  attr_accessible :date, :kt

  validates_presence_of :date
  validates_uniqueness_of :date

  has_many :visitations, :dependent => :destroy

  scope :ascending,  -> { order('date asc') }
  scope :descending, -> { order('date desc') }

end

# == Schema Information
#
# Table name: gpodays
#
#  id         :integer          not null, primary key
#  date       :date
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  kt         :boolean          default(FALSE)
#
