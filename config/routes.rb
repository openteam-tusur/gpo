Gpo::Application.routes.draw do
  namespace :manage do
    resources :themes, :except => :show do
      get :statistics, :projects, :on => :collection
    end
    resources :gpodays, :except => :show
    resources :reports, :only => [:index, :show]
    resources :visitations, :only => :index
  end


  resources :students, :collection => {:problematic => :get}

  resources :rules
  resources :chairs do
    get :managers, :on => :member
    resources :orders do
      put :update_state, :on => :member
    end
    resources :users
    resources :projects do
      member do
        get :to_close
        put :close
        put :reopen
        put :update_visitationlog
      end
      resources :participants do
        member do
          put :approve
          put :cancel
        end
        resources :issues, :only => [:new, :create, :edit, :update, :destroy] do
          get :export, :on => :collection
        end
      end
      resources :managers do
        member do
          put :approve
          put :cancel
        end
      end
      resources :stages
      resources :orders
      resources :visitations, :except => [:new, :create, :destroy]
      resources :issues, :only => [:index]
    end
  end

  resources :visitations, :only => :index

  get '/dashboard' => 'application#dashboard', :as => :dashboard
  root :to => 'application#dashboard'
end

