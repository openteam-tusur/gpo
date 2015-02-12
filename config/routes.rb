Gpo::Application.routes.draw do
  mount API::Gpo => '/api'

  namespace :manage do
    resources :themes, except: :show do
      get :statistics, :projects, on: :collection
    end

    get 'search_projects' => 'search_projects#index'

    resources :gpodays,     except: :show
    resources :reports,     only: [:index, :show]

    get '/statistics'           => 'statistics#show'
    get '/statistics/:chair_id' => 'statistics#show', :as => :chair_statistics
    post '/statistics/snapshot' => 'statistics#snapshot'
    resources :statistics, :only => [:destroy]

    resources :chairs do
      resources :visitations, only: :index

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
          resources :issues, only: [:new, :create, :edit, :update, :destroy] do
            get :export, on: :collection
          end
        end

        resources :project_managers, except: [:show, :destroy]

        resources :orders, only: :index
      end

      resources :orders, only: [:show, :index, :edit, :destroy]
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

