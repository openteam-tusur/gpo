class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager?

    can :manage, :application do
      user.permissions.any?
    end

    ## app specific

    can :manage_projects, Chair do |chair|
      user.mentor_of?(chair)
    end

    can :read, Chair do |chair|
      user.available_chairs.include?(chair)
    end

    can :read, [Issue, Order, Participant, ProjectManager, Stage, Visitation]

    can :read, Project do |project|
      user.mentor_of?(project.chair)
    end

    can :read, Project do |project|
      user.project_manager_of?(project)
    end

    can :update, Project do |project|
      can?(:read, project) && project.editable?
    end

    can :rename, Project do |project|
      can?(:update, project) && project.draft?
    end

    can [:create, :to_close, :close], Project do |project|
      can?(:update, project) && user.mentor_of?(project.chair)
    end

    can [:destroy], Project do |project|
      can?(:close, project) && project.draft?
    end

    can [:create, :update, :remove, :cancel], Participant do |participant|
      can?(:update, participant.project)
    end

    can [:create, :update, :remove, :cancel], ProjectManager  do |project_manager|
      can?(:manage_projects, project_manager.project.chair) && project_manager.project.editable?
    end

    can :manage, [Stage, Issue] do |object|
      can? :update, object.project
    end

    can :create, Order do |order|
      can? :manage_projects, order.chair
    end

    can [:update, :destroy, :to_review], Order do |order|
      can?(:manage_projects, order.chair) && order.draft?
    end

    can :manage, User do |another_user|
      another_user == user
    end

    can :manage, User do |another_user|
      user.mentor? && user.permissions.where(:role => :mentor).map(&:context).include?(another_user.chair)
    end
  end
end
