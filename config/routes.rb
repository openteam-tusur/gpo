Gpo::Application.routes.draw do
  mount API::Gpo => '/api'

  namespace :manage do
    resources :themes, except: :show do
      get :statistics, :projects, on: :collection
    end

    get 'search_projects' => 'search_projects#index'

    resources :gpodays,     except: :show
    resources :reports,     only: [:index, :show]

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

      resources :users, except: :show
      resources :project_managers, only: :index
    end

    resources :users, except: :show
    resources :permissions, except: :show

    resource :dashboard, :only => :show

    root :to => 'dashboards#show'
  end

  resources :chairs, :only => [:index] do
    resources :projects, :only => [:index, :show]
  end

  root :to => 'chairs#index'
end

