# encoding: utf-8

# == Schema Information
#
# Table name: themes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Theme < ActiveRecord::Base

  has_many :projects, :order => 'cipher'

  has_many :participants, :through => :projects

  validates_presence_of :name
  validates_uniqueness_of :name

  attr_accessible :name

  default_scope order(:name)

end
