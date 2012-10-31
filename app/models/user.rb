# encoding: utf-8

# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(40)
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  mid_name                  :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  post                      :string(255)
#  chair_id                  :integer
#  float                     :string(255)
#  phone                     :string(255)
#


class User < ActiveRecord::Base
  attr_accessible :chair_id, :last_name, :first_name, :mid_name, :post, :float, :phone, :email

  validates_presence_of     :first_name, :mid_name, :last_name

  belongs_to :chair

  # TODO: переименовать :managers в :leaderships
  has_many :leaderships, :class_name => 'Manager'
  has_many :approved_leaderships, :class_name => 'Manager', :conditions => {:state => ["approved", "awaiting_removal"]}
  has_many :projects, :through => :leaderships
  has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'

  has_many :rules, :dependent => :destroy

  default_scope order('last_name, first_name, mid_name')

  def name
    "#{last_name} #{first_name} #{mid_name}"
  end

  def initials_name
    "#{last_name} #{first_name.split(//u)[0,1].join}.#{mid_name.split(//u)[0,1].join}."
  end

  def role_symbols
   roles = (rules || []).map {|r| r.role.to_sym}
   roles << 'user'
  end

  def admin?
    self.rules.administrators.first != nil
  end

  def supervisor?
    self.rules.supervisors.first != nil
  end

  def any_mentor?
    self.rules.mentors.first != nil
  end

  def any_manager?
    self.rules.managers.first != nil
  end

  def mentor?(chair)
    self.rules.mentors.for_chair(chair).first != nil
  end

  def manager?(project)
    self.rules.managers.for_project(project).first != nil
  end

  def manager_at_chair?(chair)
    self.projects.all.find {|project| project.chair == chair} != nil
  end

  def manage_not_closed_projects?
    !(self.projects.active.empty? && self.projects.draft.empty?)
  end

  def chairs_for_mentor
    self.rules.mentors.collect {|rule| rule.chair}
  end

end
