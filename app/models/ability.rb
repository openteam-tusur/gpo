class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    can :manage, :all if user.manager?

    can :manage, :application do
      user.have_permissions?
    end

    ## app specific

  end
end
