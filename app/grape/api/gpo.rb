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
    desc 'Retrieve chairs'
    get do
      present chairs, with: API::Entities::ChairEntity
    end

    params do
      requires :id, :type => Integer, :desc => 'Chair ID'
    end
    namespace ':id' do
      desc 'Retrieve chair'
      get do
        present chair, with: API::Entities::ChairEntity
      end

      desc 'Retrieve project list for chair'
      get :projects do
        present chair.projects.active, with: API::Entities::ProjectEntity, extra: true, participants: true, url: true
      end
    end
  end

  resources :themes do
    desc 'Retrieve themes'
    get do
      present themes, with: API::Entities::ThemeEntity
    end
  end

  resources :projects do
    desc 'Retrieve projects'
    get do
      present active_projects, with: API::Entities::ProjectEntity
    end

    desc 'Retrieve project'
    get ':id' do
      present project, with: API::Entities::ProjectEntity, extra: true, participants: true
    end

    get ':id/participants' do
      present project.participants, with: API::Entities::ParticipantEntity
    end

    get ':id/project_managers' do
      present project.project_managers, with: API::Entities::ProjectManagerEntity
    end
  end

  resource :participant do
    get ':id' do
      participant = Participant.find_by(student_id: params[:id].to_s)

      participant.project.to_json(
        only: [:cipher, :title, :goal]
      ) rescue {}
    end
  end

  get :permissions do
    user = User.find_by_uid(params[:uid].to_s)
    error!('User not found') unless user.present?

    { :permissions => user.permissions.map do |permission|
      { :role => permission.role,
        :context => {
          :kind => permission.context_type,
          :remote_id => permission.context_id,
          :title => permission.context.try(:to_s)
        }
      }
    end
    }
  end
end
