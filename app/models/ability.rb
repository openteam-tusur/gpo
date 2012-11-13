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

    can [:create, :update, :remove, :cancel], Participant do |participant|
      can?(:update, participant.project)
    end

    can :read, [Issue, Order, Participant, ProjectManager, Stage, Visitation]
  end
end
