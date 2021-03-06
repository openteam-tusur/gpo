class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    alias_action :index, :update, :destroy, to: :crud
    alias_action :pdf, :pdf_all, to: :export_pdf

    can :manage, :all if user.manager?

    can :manage, :application do
      user.permissions.any?
    end

    ## app specific
    can :read, IssueAttachment

    if user.project_manager?
      can :create, Certificate
      can :crud, Certificate, state: ['initialized']
      can :approve, Certificate, state: ['initialized']
      can [:new, :create], IssueAttachment
    end

    if user.executive_participant?
      can [:new, :create], IssueAttachment
    end

    if user.mentor?
      can :new, [AttestationMark, StudentAchievement, StageAchievement]
      can [:create, :edit, :update, :destroy], [AttestationMark, StudentAchievement, StageAchievement], stage_id: user.mentor_stages
      can :create, Certificate
      can :crud, Certificate, state: ['send_to_mentor']
      can :approve, Certificate, state: ['send_to_mentor']
      can :decline, Certificate, state: ['send_to_mentor']
    end

    can :manage_projects, Chair do |chair|
      user.mentor_of?(chair)
    end

    can :manage, Person do |person|
      user.mentor_of?(person.chair)
    end

    can :read, :dashboard

    unless user.executive_participant?
      can :read, [Order, Participant, ProjectManager, Visitation]

      can [:create, :update, :remove, :cancel, :make_executive, :unmake_exicutive], Participant do |participant|
        can?(:update, participant.project)
      end

      can [:create, :update, :remove, :cancel], ProjectManager  do |project_manager|
        can?(:manage_projects, project_manager.project.chair) && project_manager.project.editable?
      end

      can :create, Order do |order|
        can? :manage_projects, order.chair
      end

      can :index, Project do |project|
        user.mentor_of?(project.chair) || user.project_manager_of?(project)
      end
    end

    can :read, Chair do |chair|
      user.available_chairs.include?(chair)
    end

    can :read, Project do |project|
      user.mentor_of?(project.chair) || user.project_manager_of?(project) || user.executive_participant_of?(project)
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

    can :read, [Stage, Issue]

    can :manage, [Stage, Issue] do |object|
      can? :update, object.project
    end

    can :manage, IssueAttachment do |object|
      can? :update, object.issue
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
