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
  #has_states :awaiting_approval, :approved, :awaiting_removal, :removed do
    #on :approve do
      #transition :awaiting_approval => :approved, :awaiting_removal => :removed
    #end
    #on :cancel do
      #transition :awaiting_approval => :removed, :awaiting_removal => :approved
    #end
    #on :remove do
      #transition :approved => :awaiting_removal
    #end
  #end

  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :user_id, :scope => [:project_id], :message => 'уже является руководителем проекта'

  belongs_to :user
  belongs_to :project

  scope :active, where(:state => %w[approved awaiting_removal])


  def state_description
    L10N[:manager]["state_#{self.state}"]
  end

  def after_enter_awaiting_approval
    Rule.build_manager_rule(self.user_id, self.project_id).save
  end

  def after_enter_removed
    Rule.managers.for_project(self.project_id).for_user(self.user_id).find(:first).destroy
    self.destroy
  end

  # для приказа
  def text_for_order_report
    "#{self.user.post} #{self.user.last_name} #{self.user.first_name[0..1]}.#{self.user.mid_name[0..1]}."
  end

  private
  def self.allowed?(user, project = nil)
    if project.editable?
      user.is_a?(User) && (user.mentor?(project.chair) || user.admin?)
    else
      user.is_a?(User) && user.admin?
    end
  end
end
