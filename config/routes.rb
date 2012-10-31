Gpo::Application.routes.draw do
  namespace :manage do
    resources :themes, except: :show do
      get :statistics, :projects, on: :collection
    end

    resources :gpodays,     except: :show
    resources :reports,     only: [:index, :show]
    resources :visitations, only: :index

    resources :chairs do

      resources :projects do
        member do
          get :to_close
          put :close, :reopen, :update_visitationlog
        end

        resources :stages
        resources :visitations, except: [:new, :create, :destroy]

        resources :managers, except: :show do
          member do
            put :approve, :cancel
          end
        end
      end

      resources :users, except: :show
    end

    resources :users, except: :show
    resources :rules, except: :show
  end

  resources :students, collection: { problematic: :get }

  resources :chairs do
    resources :visitations, only: :index
    get :managers, on: :member

    resources :orders do
      put :update_state, :on => :member
    end


    resources :projects do
      resources :participants do
        member do
          put :approve
          put :cancel
        end
        resources :issues, :only => [:new, :create, :edit, :update, :destroy] do
          get :export, :on => :collection
        end
      end
      resources :orders
      resources :issues, :only => [:index]
    end
  end

  resources :visitations, :only => :index

  get '/dashboard' => 'application#dashboard', :as => :dashboard
  root :to => 'application#dashboard'
end

