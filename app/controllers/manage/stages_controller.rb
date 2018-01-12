class Manage::StagesController < Manage::InheritedResourcesController
  layout 'project'

  before_action :check_can_update, only: [:edit, :update]
  before_action :check_can_destroy, only: [:destroy]

  belongs_to :chair, parent_class: Chair do
    belongs_to :project
  end

  def index
    index! do
      unless current_user.mentor?
        @stages = @stages.delete_if { |stage| stage.reporting_stage }
      end
    end
  end

  private

  def check_can_update
    unless resource.can_change?
      message =  'Возможность редактирования информации об этапе закончилась '
      message += I18n.l(resource.finish + 1.day, format: :long)
      message += ', в 00:00'
      flash[:error] = message
      redirect_to manage_chair_project_stage_path(params[:chair_id], params[:project_id], resource)

      return
    end
  end

  def check_can_destroy
    if resource.for_reporting?
      flash[:error] = %(Вы не можете удалить этап «#{resource.title}»)
      redirect_to manage_chair_project_stage_path(params[:chair_id], params[:project_id], resource)

      return
    end
  end
end
