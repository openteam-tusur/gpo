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
  validates_presence_of :user_id
  validates_presence_of :project_id

  validates_uniqueness_of :user_id, :scope => [:project_id], :message => 'уже является руководителем проекта'

  belongs_to :user
  belongs_to :project

  scope :active, where(:state => %w[approved awaiting_removal])

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

    after_transition any => :removed do
      Rule.managers.for_project(project).for_user(user).first.destroy
      destroy
    end

    after_transition any => :awaiting_approval do
      Rule.build_manager_rule(self.user_id, self.project_id).save
    end
  end

  # для приказа
  def text_for_order_report
    "#{self.user.post} #{self.user.last_name} #{self.user.first_name[0..1]}.#{self.user.mid_name[0..1]}."
  end
end
