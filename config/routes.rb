Gpo::Application.routes.draw do
  mount API::Gpo => '/'

  namespace :manage do
    resources :themes, except: :show do
      get :statistics, :projects, on: :collection
    end

    resources :gpodays,     except: :show
    resources :reports,     only: [:index, :show]
    resources :visitations, only: :index

    resources :chairs do
      resources :visitations, only: :index

      resources :projects do
        member do
          get :to_close
          put :close, :reopen, :update_visitationlog
        end

        resources :stages
        resources :visitations, except: [:new, :create, :destroy]
        resources :issues, only: [:index]

        resources :participants, except: [:destroy] do
          resources :issues, only: [:new, :create, :edit, :update, :destroy] do
            get :export, on: :collection
          end
        end

        resources :managers, except: [:show, :destroy]

        resources :orders, only: :index
      end

      resources :orders, except: [:new, :create, :update]
      resources :opening_orders, only: [:new, :create, :update]
      resources :workgroup_orders, only: [:new, :create, :update]

      resources :users, except: :show
      resources :managers, only: :index
    end

    resources :users, except: :show
    resources :rules, except: :show

    get '/dashboard' => 'application#dashboard', :as => :dashboard
    root :to => 'application#dashboard'
  end

  resources :chairs, :only => [:index] do
    resources :projects, :only => [:index, :show]
  end

  root :to => 'chairs#index'
end

