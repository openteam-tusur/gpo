# encoding: utf-8

class User < ActiveRecord::Base
  validates_presence_of     :first_name, :mid_name, :last_name

  belongs_to :chair

  # TODO: переименовать :managers в :leaderships
  has_many :leaderships, :class_name => 'Manager'
  has_many :approved_leaderships, :class_name => 'Manager', :conditions => {:state => ["approved", "awaiting_removal"]}
  has_many :projects, :through => :leaderships
  has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'

  has_many :rules, :dependent => :destroy

  def initialize(attributes = {})
    super(attributes)
    if attributes.has_key?(:name)
      name = attributes[:name]
      self.last_name = name.split(" ")[0]
      self.first_name = name.split(" ")[1]
      self.mid_name = name.split(" ")[2]
    end
  end

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
