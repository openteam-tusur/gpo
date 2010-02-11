authorization do
  role :guest do
    has_permission_on :sessions, :to => :create
  end

  role :user do
    has_permission_on :sessions, :to => [:new, :dashboard, :destroy]
  end

  role :manager do
    includes :user
    # может просматривать кафедры и руководителей проектов только кафедр, на которых он является руководителем проекта
    has_permission_on :chairs, :to => [:read, :managers] do
      if_attribute :all_managers => contains {user}
    end

    # может просматривать свои проекты
    has_permission_on :projects, :to => :read do
      if_attribute :users => contains {user}
    end
    # может редактировать свои проекты, которые незакрыты и редактируемые
    has_permission_on :projects, :to => :update, :join_by => :and do
      if_attribute :closed? => false
      if_attribute :editable? => true
      if_attribute :users => contains {user}
    end
    has_permission_on :projects, :to => :rename, :join_by => :and do
      if_attribute :draft? => true
      if_attribute :editable? => true
    end

    # УЧАСТНИКИ
    has_permission_on :participants, :to => :create, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :can_create? => true
    end
    has_permission_on :participants, :to => :cancel, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => false
    end
    has_permission_on :participants, :to => :delete, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => true
    end
  end

  role :mentor do
    includes :user
    # может просматривать и редактировать свои кафедры
    has_permission_on :chairs, :to => [:read, :managers, :chair_manage] do
      if_attribute :mentors => contains {user}
    end

    # может просматривать проекты своей кафедры
    has_permission_on :projects, :to => :read do
      if_attribute :chair => {:mentors => contains {user}}
    end
    # может управлять незакрытыми, редактируемыми проектами на своей кафедре
    has_permission_on :projects, :to => :update, :join_by => :and do
      if_attribute :closed? => false
      if_attribute :editable? => true
      if_attribute :chair => {:mentors => contains {user}}
    end
    # может закрывать незакрытые, редактируемые проекты без участников на своей кафедре
    has_permission_on :projects, :to => :close, :join_by => :and do
      if_attribute :closed? => false
      if_attribute :editable? => true
      if_attribute :participants => is {[]}
      if_attribute :chair => {:mentors => contains {user}}
    end
    # может удалять черновики проектов своей кафедры
    has_permission_on :projects, :to => :delete, :join_by => :and do
      if_attribute :draft? => true
      if_attribute :editable? => true
      if_attribute :chair => {:mentors => contains {user}}
    end
    has_permission_on :projects, :to => :rename, :join_by => :and do
      if_attribute :draft? => true
      if_attribute :editable? => true
    end

    # Управление руководителями проектов
    has_permission_on :managers, :to => :create, :join_by => :and do
      if_permitted_to :update, :project
    end
    has_permission_on :managers, :to => :cancel, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => false
    end
    has_permission_on :managers, :to => :delete, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => true
    end


    # УПРАВЛЕНИЕ ПОЛЬЗОВАТЕЛЯМИ
    # может создавать и редактировать пользователей на своей кафедре
    has_permission_on :users, :to => [:create, :update] do
      if_attribute :chair => is_in {user.chairs_for_mentor}
    end
    # может удалять пользователей своей кафедры, кроме себя, менторов своей кафедры и руководителей незакрытых проектов
    has_permission_on :users, :to => :delete, :join_by => :and do
      if_attribute :id => is_not {user.id}
      if_attribute :manage_not_closed_projects? => false
      if_attribute :chair_id => is {user.chair_id}
      if_attribute :any_mentor? => false
    end

    # УЧАСТНИКИ
    has_permission_on :participants, :to => :create, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :can_create? => true
    end
    has_permission_on :participants, :to => :cancel, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => false
    end
    has_permission_on :participants, :to => :delete, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => true
    end

    # Приказы
    has_permission_on [:orders, :ordinances], :to => :create do
      if_permitted_to :chair_manage, :chair
    end
    has_permission_on [:orders, :ordinances],  :to => [:update, :to_review, :delete], :join_by => :and do
      if_permitted_to :chair_manage, :chair
      if_attribute :draft? => true
    end

  end

  role :supervisor do
    includes :user
    # может просматривать все кафедры
    has_permission_on :chairs, :to => [:read, :managers]
    # может просматривать все проекты
    has_permission_on :projects, :to => :read
    # может просматривать студентов (не используется)
    has_permission_on :students, :to => [:read, :problematic]
    # может просматривать и утверждать руководителей проектов
    has_permission_on :managers, :to => :read
    has_permission_on :managers, :to => [:approve] do
      if_attribute :approved? => false
    end


    # УПРАВЛЕНИЕ
    has_permission_on :themes, :to => [:manage, :projects, :statistics]
    has_permission_on :gpodays, :to => [:manage]

    # ОТЧЕТЫ
    has_permission_on :reports, :to => :read

    # Приказы
    has_permission_on [:orders, :ordinances], :to => :delete do
      if_attribute :draft? => true
      if_attribute :being_reviewed? => true
      if_attribute :reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => :update do
      if_attribute :approved? => true
    end
    has_permission_on [:orders, :ordinances], :to => :review do
      if_attribute :being_reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => :cancel do
      if_attribute :being_reviewed? => true
      if_attribute :reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => [:approve] do
      if_attribute :reviewed? => true
    end
    has_permission_on :visitations, :to => :read
  end

  role :admin do
    includes :user
    # может управлять всеми кафедрами
    has_permission_on :chairs, :to => [:manage, :managers, :chair_manage]

    # УПРАВЛЕНИЕ ПРАВИЛАМИ
    # может смотреть, создавать, редактировать правила
    has_permission_on :rules, :to => [:read, :create, :update]
    # может удаляить правила, если это не руководитель проекта
    has_permission_on :rules, :to => :delete do
      if_attribute :user => {:manage_not_closed_projects? => false}
    end

    # УПРАВЛЕНИЕ
    has_permission_on :themes, :to => [:manage, :projects, :statistics]
    has_permission_on :gpodays, :to => [:manage]

    has_permission_on :students, :to => [:manage, :problematic]

    # может просматривать, создавать и редактировать любые проекты
    has_permission_on :projects, :to => [:read, :create, :update]
    # может удалять только редактируемые черновики проектов
    has_permission_on :projects, :to => :delete, :join_by => :and do
      if_attribute :editable? => true
      if_attribute :draft? => true
    end
    # может закрывать только незакрытые, редактируемые проекты, в которых нет участников
    has_permission_on :projects, :to => :close, :join_by => :and do
      if_attribute :closed? => false
      if_attribute :editable? => true
      if_attribute :participants => is {[]}
    end
    # может возобновлять только закрытые проекты
    has_permission_on :projects, :to => :reopen do
      if_attribute :closed? => true
    end
    # может переименовывать проекты
    has_permission_on :projects, :to => :rename do
      if_attribute :closed? => false
    end

    # может управлять руководителями проектов
    has_permission_on :managers, :to => [:read, :create, :update]
    has_permission_on :managers, :to => :delete do
      if_attribute :approved? => true
    end
    has_permission_on :managers, :to => [:cancel, :approve] do
      if_attribute :approved? => false
    end

    # может смотреть, создавать и обновлять любых пользователями
    has_permission_on :users, :to => [:read, :create, :update]
    # может удалять любых пользователей кроме себя и руководителей незакрытых проектов
    has_permission_on :users, :to => :delete, :join_by => :and do
      if_attribute :id => is_not {user.id}
      if_attribute :manage_not_closed_projects? => false
    end

    # УЧАСТНИКИ
    has_permission_on :participants, :to => :create, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :can_create? => true
    end
    has_permission_on :participants, :to => :cancel, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => false
    end
    has_permission_on :participants, :to => :approve do
      if_attribute :approved? => false
    end
    has_permission_on :participants, :to => :delete, :join_by => :and do
      if_permitted_to :update, :project
      if_attribute :approved? => true
    end

    # ОТЧЕТЫ
    has_permission_on :reports, :to => :read

    # Приказы
    has_permission_on [:orders, :ordinances], :to => :create
    has_permission_on [:orders, :ordinances], :to => :update do
      if_attribute :draft? => true
      if_attribute :approved? => true
    end
    has_permission_on [:orders, :ordinances], :to => :to_review do
      if_attribute :draft? => true
    end
    has_permission_on [:orders, :ordinances], :to => :review do
      if_attribute :being_reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => :cancel do
      if_attribute :being_reviewed? => true
      if_attribute :reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => [:approve] do
      if_attribute :reviewed? => true
    end
    has_permission_on [:orders, :ordinances], :to => :delete
    has_permission_on :visitations, :to => :read
  end

end

privileges do
  privilege :manage, :includes => [:create, :read, :update, :delete]
  privilege :read, :includes => [:index, :show]
  privilege :create, :includes => :new
  privilege :update, :includes => :edit
  privilege :delete, :includes => :destroy
end

