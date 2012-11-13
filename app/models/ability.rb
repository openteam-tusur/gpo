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

    can :read, Chair do |chair|
      user.mentor_of?(chair)
    end

    can :read, Chair do |chair|
      user.managable_projects.where(:chair_id => chair).any?
    end

    can :manage, Project do |project|
      user.mentor_of? project.chair
    end

    can [:update, :read, :manage], Project do |project|
      user.project_manager_of?(project)
    end

    can :manage, [Stage, Visitation, Issue] do |object|
      can? :update, object.project
    end

    can :read, [ProjectManager, Participant] do |object|
      can?(:update, object.project) && !object.state_event?
    end

    can :update, [ProjectManager, Participant] do |object|
      can?(:update, object.project) && !object.state_event
    end

    can :update, [ProjectManager, Participant] do |object|
      can?(:update, object.project) && object.state_event && can?(object.state_event, object.project)
    end

    can :modify, Order do |order|
      user.mentor_of? order.chair
    end

    can [:create, :remove], Participant do |participant|
      can?(:update, participant.project)
    end
  end
end
