# encoding: utf-8

class Manage::VisitationsController < ApplicationController
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
  end

  def update
    @errors = []
    @gpoday = Gpoday.find(params[:id])
    params[:participant].each do |participant_with_rate|
      participant = @project.participants.find(participant_with_rate[0])
      visitation = participant.visitation_for_gpoday(@gpoday)
      visitation.rate = participant_with_rate[1].gsub(",", ".")
      unless visitation.save
        @errors << participant.id
      end
    end

    if @errors.empty?
      flash[:notice] = "Баллы сохранены"
      redirect_to manage_chair_project_visitations_path(@project.chair, @project)
    else
      flash[:error] = "Ошибка сохранения баллов"
      render :edit
    end
  end

  protected

  def authorize_resource
    authorize! :update, resource
  end

  def find_context
    @chair = Chair.find_by_id(params[:chair_id])
    @project = Project.find_by_id(params[:project_id])
  end

  def resource
    @project || @chair
  end

  def resource_name
    resource.class.model_name.underscore
  end
end

