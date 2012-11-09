# encoding: utf-8

# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  role         :string(255)
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime
#  updated_at   :datetime
#

class Permission < ActiveRecord::Base
  attr_accessible :user, :context

  # FIXME fix this shit!
  alias_attribute :chair_id, :context_id
  attr_accessible :user_id, :context_id, :role, :chair_id

  validates_presence_of   :user_id
  validates_uniqueness_of :user_id, :scope => [:role, :context_type, :context_id], :message => 'уже имеет такое правило'

  validates_presence_of   :chair_id,    :if => Proc.new { |permission| permission.role == 'mentor' }
  validates_presence_of   :project_id,  :if => Proc.new { |permission| permission.role == 'project_manager' }

  scope :managers,          where(:role => :manager)
  scope :mentors,           where(:role => :mentor)
  scope :project_managers,  where(:role => :project_manager)
  scope :for_user,          ->(user)    { where(:user_id => user) }
  scope :for_project,       ->(project) { where(:context_type => Project).where(:context_id => project) }
  scope :for_chair,         ->(chair)   { where(:context_type => Chair).where(:context_id => chair) }

  esp_auth_permission

  def role_with_context
    [human_role, context.id_to_s].compact.join(' ') rescue p self
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
      when "manager"
        context_type = nil
        context_id = nil
      when "mentor"
        context_type = Chair.name
        context_id = chair_id
      when "project_manager"
        context_type = Project.name
        context_id = project_id
    end
    params[:context_id] = context_id
    params[:context_type] = context_type
    params
  end

  def self.build_project_manager_permission(user, project)
    Permission.new(:user => user, :context => project, :role => 'project_manager')
  end
end