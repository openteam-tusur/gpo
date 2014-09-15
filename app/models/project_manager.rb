# encoding: utf-8
# == Schema Information
#
# Table name: project_managers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  state      :string(255)
#

class ProjectManager < ActiveRecord::Base
  attr_accessible :user_id, :state_event

  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :user_id, :scope => [:project_id], :message => 'уже является руководителем проекта'

  belongs_to :user
  belongs_to :project

  scope :active,   -> { where(:state => %w[approved awaiting_removal]) }

  scope :approved, -> { where(:state => 'approved') }

  scope :awaiting, -> { where(:state => %w[awaiting_approval awaiting_removal]) }

  delegate :first_name, :last_name, :middle_name, :email, to: :user

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

    after_transition :awaiting_approval => :removed do |project_manager|
      project_manager.destroy
    end

    after_transition :awaiting_removal => :removed do |project_manager, transition|
      Permission.project_managers.for_project(project_manager.project).for_user(project_manager.user).destroy_all
      project_manager.destroy
    end

    after_transition any => :approved do |project_manager, transition|
      Permission.build_project_manager_permission(project_manager.user, project_manager.project).save
    end
  end

  # для приказа
  def text_for_order_report
    "#{self.user.post} #{self.user.initials_name}"
  end

  def <=>(other)
    user.last_name <=> other.user.last_name
  end
end
