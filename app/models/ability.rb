class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    alias_action :read, :create, :update, :destroy, :to => :modify

    can :manage, :all if user.manager?

    can :manage, :application do
      user.have_permissions?
    end

    ## app specific

    can :manage_projects, Chair do |chair|
      user.mentor_of?(chair)
    end

    can :read, Chair do |chair|
      user.available_chairs.include?(chair)
    end

    can :read, [Issue, Order, Participant, ProjectManager, Stage, Visitation]

    can :manage, Project do |project|
      user.mentor_of? project.chair
    end

    can [:update, :read], Project do |project|
      user.project_manager_of?(project)
    end

    can [:create, :update, :remove, :cancel], Participant do |participant|
      can?(:update, participant.project)
    end

    can [:create, :update, :remove, :cancel], ProjectManager  do |project_manager|
      can? :manage_projects, project_manager.project.chair
    end

    can :manage, [Stage, Issue] do |object|
      can? :update, object.project
    end
  end
end
