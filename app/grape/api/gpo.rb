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

    get ':id/reporting_marks' do
      reporting_marks = ReportingMark.
        where(contingent_id: params[:id]).
        where.not(mark: [nil, '']).
        includes(:stage, stage: :project).
        order('stages.start desc')
      reporting_marks.map do |rm|
        {
          stage: {
            contingent_id: params[:id],
            fullname: rm.fullname,
            title: rm.stage.title,
            start: I18n.l(rm.stage.start),
            finish: I18n.l(rm.stage.finish),
            link_to_report: %(#{Settings['app.url']}#{rm.stage.file_report_path}),
            file_report_updated_at: (I18n.l(rm.stage.file_report_updated_at) rescue nil),
            link_to_review: %(#{Settings['app.url']}#{rm.stage.file_review_path}),
            file_review_updated_at: (I18n.l(rm.stage.file_review_updated_at) rescue nil),
            mark: rm.mark,
            updated_at: I18n.l(rm.stage.updated_at),
            project: {
              cipher: rm.stage.project.cipher,
              title: rm.stage.project.title,
              goal: rm.stage.project.goal,
            }
          }
        }
      end
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
