# encoding: utf-8

# == Schema Information
#
# Table name: chairs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  chief      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'task'

class Chair < ActiveRecord::Base
  validates_presence_of :title, :abbr, :chief
  validates_uniqueness_of :abbr

  has_many :projects, :order => 'cipher desc'
  has_many :orders, :order => 'id desc'
  has_many :workgroup_orders, :order => 'id desc'
  has_many :opening_orders, :order => 'id desc'
  has_many :users, :order => 'last_name'
  has_many :participants, :order => 'last_name'
  has_many :activities, :dependent => :destroy, :order => 'created_at desc', :limit => 10
  has_one :last_activity, :class_name => 'Activity', :order => 'created_at'

  has_many :rules, :as => :context
  has_many :mentors, :through => :rules, :conditions => ["rules.role = ?", 'mentor'], :source => :user, :order => "last_name"

  def id_to_s
    self.abbr
  end

  def managers
    managers = []
    self.projects.each do |project|
      managers += project.managers.approved.collect { |m| m.user }
    end
    managers.uniq!
    managers.sort{|a, b| a.last_name <=> b.last_name}
  end

  def all_managers
    managers = []
    self.projects.each do |project|
      managers += project.managers.collect { |m| m.user }
    end
    managers
  end

  def build_order(type, params = {})
    case type
    when "WorkgroupOrder"
      @order = self.workgroup_orders.build(params)
    when "OpeningOrder"
      @order = self.opening_orders.build(params)
    else
      raise "Неверный тип приказа"
    end
  end

  def stats(*types)
    Stat.for_chair(self, *types)
  end

  def tasks(user, context = nil)
    Task.tasks_for(user, self, context)
  end
end
