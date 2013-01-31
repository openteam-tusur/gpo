class API::Gpo < Grape::API
  format :json

  helpers do
    def chairs
      @chairs ||= Chair.scoped
    end

    def themes
      @themes ||= Theme.scoped
    end

    def active_projects
      @active_projects ||= Project.active
    end

    def project
      @project ||= active_projects.find(params[:id])
    end

    def chair
      @chair ||= chairs.find(params[:id])
    end
  end

  resources :chairs do
    desc 'Returns chairs'
    get do
      present chairs, with: API::Entities::ChairEntity
    end

    params do
      requires :id, :type => Integer, :desc => 'Chair ID'
    end
    namespace ':id' do
      desc 'Retrieve project list for chair'
      get :projects do
        present chair.projects.active, with: API::Entities::ProjectEntity, extra: true, url: true
      end
    end
  end

  resources :themes do
    desc 'Returns themes'
    get do
      present themes, with: API::Entities::ThemeEntity
    end
  end

  resources :projects do
    desc 'Returns projects'
    get do
      present active_projects, with: API::Entities::ProjectEntity
    end

    get ':id' do
      present project, with: API::Entities::ProjectEntity, extra: true, participants: true
    end
  end
end
