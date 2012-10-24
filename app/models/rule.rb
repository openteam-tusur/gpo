# encoding: utf-8

# == Schema Information
#
# Table name: rules
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  role         :string(255)
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Rule < ActiveRecord::Base

  belongs_to :user
  belongs_to :context, :polymorphic => true

  validates_presence_of   :user_id
  validates_uniqueness_of :user_id, :scope => [:role, :context_type, :context_id], :message => 'уже имеет такое правило'

  validates_presence_of   :chair_id,    :if => Proc.new { |rule| rule.role == 'mentor' }
  validates_presence_of   :project_id,  :if => Proc.new { |rule| rule.role == 'manager' }

  scope :administrators,  where(:role => :admin)
  scope :supervisors,     where(:role => :supervisors)
  scope :managers,        where(:role => :manager)
  scope :mentors,         where(:role => :mentor)
  scope :for_user,        ->(user)    { where(:user_id => user) }
  scope :for_project,     ->(project) { where(:context_type => Project).where(:context_id => project) }
  scope :for_chair,       ->(chair)   { where(:context_type => Chair).where(:context_id => chair) }

  def role_with_context
    if context.nil?
      role_to_s
    else
     "#{role_to_s} #{context.id_to_s}"
    end
  end

  def chair
    self.context if self.context_type == Chair.name
  end

  def chair_id
    context_id unless chair.nil?
  end

  def project
    self.context if self.context_type == Project.name
  end

  def project_id
    context_id unless project.nil?
  end

  def self.attributes_from_params(params)
    chair_id = params.delete(:chair_id)
    project_id = params.delete(:project_id)
    case params[:role]
      when "admin"
        context_type = nil
        context_id = nil
      when "mentor"
        context_type = Chair.name
        context_id = chair_id
      when "manager"
        context_type = Project.name
        context_id = project_id
    end
    params[:context_id] = context_id
    params[:context_type] = context_type
    params
  end

  def self.build_manager_rule(user_id, project_id)
    Rule.new(:user_id => user_id, :context_type => Project.name, :context_id => project_id, :role => 'manager')
  end

  def admin?
    self.role == 'admin'
  end

  def manager?
    self.role == 'manager'
  end
end
