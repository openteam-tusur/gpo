Gpo::Application.routes.draw do
  mount API::Gpo => '/api'

  get '/system/*path', to: 'attachments#show', as: :download_attachment

  namespace :manage do
    resources :themes, except: :show do
      get :statistics, :projects, on: :collection
    end

    get 'search_projects' => 'search_projects#index'

    resources :gpodays, except: :show do
      get :new_interval, on: :collection
      post :create_from_interval, on: :collection
    end
    resources :stage_achievements
    resources :student_achievements
    resources :attestation_marks
    resources :reporting_stages
    resources :reports, only: [:index, :show] do
      get :preview, on: :member
      get :edit_schedule_group
      get :edit_schedule_manager
      get :edit_chair_attestation
      put :update_schedule_group
      put :update_schedule_manager
      put :update_chair_attestation
    end

    get '/statistics'           => 'statistics#show'
    get '/statistics/:chair_id' => 'statistics#show', :as => :chair_statistics
    post '/statistics/snapshot' => 'statistics#snapshot'
    resources :statistics, :only => [:destroy]

    resources :certificates, except: [:new, :edit, :show] do
      member do
        post :approve
        post :decline
        get :pdf
      end

      get :pdf_all, on: :collection
    end

    resources :chairs do
      resources :visitations, only: :index
      resources :certificates, except: [:new, :edit, :show] do
        member do
          post :approve
          post :decline
          get :pdf
        end

        get :pdf_all, on: :collection
      end

      resources :projects do
        member do
          get :to_close
          put :close, :reopen, :update_visitationlog
        end

        resources :stages
        resources :visitations, only: [:index, :edit, :update]
        resources :issues, only: [:index]

        resources :participants, except: [:destroy] do
          put :make_executive, :on => :member
          put :unmake_executive, :on => :member
          resources :issues, only: [:new, :create, :edit, :update, :destroy] do
            get :export, on: :collection
            resources :issue_attachments
          end
        end

        resources :alien_participants, :only => [:new, :create, :update, :show]

        resources :project_managers, except: [:show, :destroy]

        resources :orders, only: :index
      end

      resources :orders, only: [:show, :index, :edit, :destroy] do
        get :preview, on: :member
      end
      resources :opening_orders, only: [:new, :create, :update]
      resources :workgroup_orders, only: [:new, :create, :update]

      resources :people, except: :show
      resources :project_managers, only: :index
    end

    resources :people, except: :show
    resources :permissions, except: [:show, :edit]

    resource :dashboard, :only => :show

    root :to => 'dashboards#show'
  end

  get '/users/search' => 'users#search'

  resources :chairs, :only => [:index] do
    resources :projects, :only => [:index, :show]
  end

  root :to => 'chairs#index'
end
