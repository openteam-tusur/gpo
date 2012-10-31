# encoding: utf-8

# == Schema Information
#
# Table name: managers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

class Manager < ActiveRecord::Base
  attr_accessible :user_id

  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :user_id, :scope => [:project_id], :message => 'уже является руководителем проекта'

  belongs_to :user
  belongs_to :project

  scope :active, where(:state => %w[approved awaiting_removal])

  scope :approved, where(:state => 'approved')

  state_machine :state, :initial => :awaiting_approval do
    event :approve do
      transition :awaiting_approval => :approved, :awaiting_removal => :removed
    end
    event :cancel do
      transition :awaiting_approval => :removed, :awaiting_removal => :approved
    end
    event :remove do
      transition :approved => :awaiting_removal
    end

    after_transition :awaiting_approval => :removed do |manager, transition|
      manager.destroy
    end

    after_transition :awaiting_removal => :removed do |manager, transition|
      Rule.managers.for_project(manager.project).for_user(manager.user).first.destroy
      manager.destroy
    end

    after_transition any => :approved do |manager, transition|
      Rule.build_manager_rule(manager.user, manager.project).save
    end
  end

  # для приказа
  def text_for_order_report
    "#{self.user.post} #{self.user.last_name} #{self.user.first_name.first}.#{self.user.mid_name.first}."
  end
end
