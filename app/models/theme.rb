# encoding: utf-8
# == Schema Information
#
# Table name: themes
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Theme < ActiveRecord::Base
  attr_accessible :name

  has_many :projects, :order => 'cipher'
  has_many :participants, :through => :projects

  validates_presence_of :name
  validates_uniqueness_of :name

  default_scope order(:name)
end
