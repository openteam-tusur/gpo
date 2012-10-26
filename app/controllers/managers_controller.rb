# encoding: utf-8

class ManagersController < ApplicationController
  before_filter :find_chair, :except => [:index, :approve]
  before_filter :find_project
  before_filter :find_manager, :except => [:index, :new, :create]
  before_filter :prepare_manager, :only => [:new, :create]
  layout 'project'
    permitted_to?(:create, @manager)
  end
  
  def index
    @managers = @project.managers.find(:all)
    @managers.sort!{|a,b| a.user.last_name <=> b.user.last_name}
  end

  def new
  end

  def create
    if @manager.save
      flash[:notice] = 'Руководитель успешно добавлен'
      redirect_to_managers_list
    else
      render :action => "new"
    end
  end

  def approve
    #authorize @manager.can_send_approve?(current_user)
    awaiting_approval = @manager.awaiting_approval?
    if @manager.approve
      if awaiting_approval
        flash[:notice] = "Назначение руководителя проекта подтверждено"
      else
        flash[:notice] = "Удаление руководителя проекта подтверждено"
      end
    end
    redirect_to_managers_list
  end

  def cancel
    #authorize @manager.can_send_cancel?(current_user)
    awaiting_approval = @manager.awaiting_approval?
    if @manager.cancel
      if awaiting_approval
        flash[:notice] = "Назначение руководителя отменено"
      else
        flash[:notice] = "Удаление руководителя проекта отменено"
      end
    end
    redirect_to_managers_list
  end

  def destroy
    #authorize can_destroy?(@manager)
    
    if @manager.remove
      flash[:notice] = "Руководитель помечен на удаление"
    end
    redirect_to_managers_list
  end
  
  private
  def find_project
    @project = Project.find(params[:project_id])
  end
  
  def find_chair
    @chair = Chair.find(params[:chair_id])
  end

  def find_manager
    @manager = @project.managers.find(params[:id])
  end
  
  def prepare_manager
    @manager = @project.managers.build(params[:manager])
  end

  def redirect_to_managers_list
    redirect_to chair_project_managers_path(@project.chair, @project)
  end
end
