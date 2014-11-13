class ProjectManager < ActiveRecord::Base
  attr_accessible :person_id, :state_event

  belongs_to :person
  belongs_to :project

  validates_presence_of   :person_id, :project_id
  validates_uniqueness_of :person_id, :scope => [:project_id], :message => 'уже является руководителем проекта'

  scope :active,   -> { where(:state => %w[approved awaiting_removal]) }
  scope :approved, -> { where(:state => 'approved') }
  scope :awaiting, -> { where(:state => %w[awaiting_approval awaiting_removal]) }

  delegate :name, :surname, :patronymic, :email, :to => :user, :allow_nil => true

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
      Permission.for_role(:project_manager).for_project(project_manager.project).for_user(project_manager.person.user_id).destroy_all
      project_manager.destroy
    end

    after_transition any => :approved do |project_manager, transition|
      Permission.build_project_manager_permission(project_manager.person, project_manager.project).try :save
    end
  end

  def text_for_order_report
    "#{person.post} #{person.initials_name}"
  end

  def <=>(other)
    person.last_name <=> other.person.last_name
  end

  def user
    @user ||= person.user
  end
end
