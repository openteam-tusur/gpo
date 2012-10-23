class Theme < ActiveRecord::Base
  
  has_many :projects, :order => 'cipher'
  
  has_many :participants, :through => :projects
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
end
