Gpo::Application.routes.draw do
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

        resources :participants do
          put :approve, :cancel, on: :member

          resources :issues, only: [:new, :create, :edit, :update, :destroy] do
            get :export, on: :collection
          end
        end

        resources :managers, except: :show do
          put :approve, :cancel, on: :member
        end
        resources :orders, only: :index
      end

      resources :orders, only: [:index, :destroy, :edit, :show] do
        put :update_state, :on => :member
      end
      resources :opening_orders, except: [:index, :destroy, :edit]
      resources :workgroup_orders, except: [:index, :destroy, :edit]

      resources :users, except: :show
    end

    resources :users, except: :show
    resources :rules, except: :show
  end

  resources :students, collection: { problematic: :get }

  resources :chairs do
    resources :visitations, only: :index
    get :managers, on: :member



    resources :projects do
      resources :participants do
        member do
          put :approve
          put :cancel
        end
      end
    end
  end


  get '/dashboard' => 'application#dashboard', :as => :dashboard
  root :to => 'application#dashboard'
end

