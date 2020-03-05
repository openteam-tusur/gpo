# encoding: utf-8

class Manage::VisitationsController < Manage::ApplicationController
  before_filter :find_context
  before_filter :authorize_resource
  helper_method :resource

  layout :resource_name

  def index
    render resource_name
  end

  def edit
    @errors = []
    @gpoday = Gpoday.find(params[:id])
    @gporate ='%.2f' % (25.0 / Gpoday.count)
  end

  def update
    @gporate ='%.2f' % (25.0 / Gpoday.count)
    @errors = []
    @gpoday = Gpoday.find(params[:id])
    params[:participant].each do |participant_id, rate|
      participant = @project.participants.find(participant_id)
      visitation = participant.visitations.find_or_initialize_by(gpoday_id: @gpoday.id)
      visitation.rate = rate.gsub(',', '.')
      unless visitation.save
        @errors << participant.id
      end
    end

    if @errors.empty?
      flash['notice'] = 'Баллы сохранены'
      redirect_to manage_chair_project_visitations_path(@project.chair, @project)
    else
      flash['error'] = 'Ошибка сохранения баллов'
      render :edit
    end
  end

  protected

  def authorize_resource
    resource.is_a?(Project) && authorize!(:update, resource)
    resource.is_a?(Chair) && authorize!(:manage_projects, resource)
  end

  def find_context
    @chair = Chair.find_by_id(params[:chair_id])
    @project = Project.find_by_id(params[:project_id])
  end

  def resource
    @project || @chair
  end

  def resource_name
    resource.class.name.underscore
  end
end
