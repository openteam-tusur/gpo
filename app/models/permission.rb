class Permission < ActiveRecord::Base
  include AuthClient::Permission

  acts_as_auth_client_permission :roles => [:manager, :mentor, :project_manager, :executive_participant]

  attr_accessor :name

  attr_accessible :user, :name, :context

  attr_accessible :user_id, :context_id, :role, :context_type

  validates_presence_of   :user

  validates_uniqueness_of :user_id, :scope => [:role, :context_type, :context_id], :message => 'уже имеет такое правило'

  #scope :managers,          -> { where(:role => :manager) }
  #scope :mentors,           -> { where(:role => :mentor) }
  #scope :project_managers,  -> { where(:role => :project_manager) }
  scope :for_user,          ->(user)    { where(:user_id => user) }
  scope :for_project,       ->(project) { where(:context_type => Project).where(:context_id => project) }
  #scope :for_chair,         ->(chair)   { where(:context_type => Chair).where(:context_id => chair) }

  searchable do
    text(:email)                  { user.email if user}
    text(:fullname)               { user.fullname if user}
  end

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

  def self.build_project_manager_permission(person, project)
    Permission.new(:user_id => person.user_id, :context => project, :role => 'project_manager') if person.user
  end

  def to_s
    [I18n.t(role, :scope => :role), context.try(&:id_to_s)].compact.join(' ')
  end

end

# == Schema Information
#
# Table name: permissions
#
#  id           :integer          not null, primary key
#  user_id      :string(255)
#  role         :string(255)
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  old_user_uid :integer
#  old_user_id  :integer
#
