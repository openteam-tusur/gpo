Gpo::Application.routes.draw do
  resources :themes, :except => :show, :collection => {:projects => :get, :statistics => :get}
  resources :gpodays, :except => :show

  resources :students, :collection => {:problematic => :get}

  resources :reports
  resources :rules
  resources :chairs do
    get :managers, :on => :member
    resources :orders do
      put :update_state, :on => :member
    end
    resources :users
    resources :visitations, :only => :index
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

