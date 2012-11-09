class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager?

    can :manage, :application do
      user.have_permissions?
    end

    ## app specific

    can :manage, Project do |project|
      user.mentor_of? project.chair
    end

    can :manage, Project do |project|
      user.project_manager_of? project
    end

    can :manage, Stage do |stage|
      can? :manage, stage.project
    end
  end
end
