ActionController::Routing::Routes.draw do |map|
  map.resources :themes, :except => :show, :collection => {:projects => :get, :statistics => :get}
  map.resources :gpodays, :except => :show

  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'

  map.forgot_password '/forgot_password', :controller => 'passwords', :action => 'new'
  map.change_password '/change_password/:reset_code', :controller => 'passwords', :action => 'reset'

  map.error_access_denied '/access_denied', :controller => 'application', :action => 'error_access_denied'

  map.resources :passwords
  map.resources :students, :collection => {:problematic => :get}

  map.resources :reports
  map.resources :rules
  map.resources :chairs, :member => { :managers => :get } do |chairs|
    chairs.resources :orders, :member => { :update_state => :put }
    chairs.resources :users
    chairs.resources :visitations, :only => :index
    chairs.resources :projects, :member => {:to_close => :get, :close => :put, :reopen => :put, :update_visitationlog => :put} do |projects|
      projects.resources :participants, :member => {:approve => :put, :cancel => :put} do |participant|
        participant.resources :issues, :only => [:new, :create, :edit, :update, :destroy], :collection => {:export => :get}
      end
      projects.resources :managers, :member => {:approve => :put, :cancel => :put}
      projects.resources :stages
      projects.resources :orders
      projects.resources :visitations, :except => [:new, :create, :destroy]
      projects.resources :issues, :only => [:index]
    end
  end

  map.resources :visitations, :only => :index

  map.resources :users
  map.resource :session

  map.dashboard '/dashboard', :controller => 'sessions', :action => 'dashboard'

  map.root :controller => "sessions", :action => "new"

  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

