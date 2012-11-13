class API::Gpo < Grape::API
  prefix :api
  format :json

  helpers do
    def chairs
      @chairs ||= Chair.all
    end

    def themes
      @themes ||= Theme.all
    end

    def active_projects
      @active_projects ||= Project.active
    end

    def project
      @project ||= active_projects.find(params[:id])
    end
  end

  resources :chairs do
    desc 'Returns chairs'
    get do
      present chairs, with: API::Entities::ChairEntity
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
      present project, with: API::Entities::ProjectEntity, full: true
    end
  end
end
