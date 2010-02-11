class ProjectsController < ApplicationController
  before_filter :find_chair
  before_filter :find_project, :except => [:index, :new, :create]
  layout 'chair'
  filter_access_to [:index], :require => :read, :context => :chairs, :attribute_check => true
  filter_access_to [:new, :create], :require => :chair_manage, :context => :chairs, :attribute_check => true
  filter_access_to :show, :require => :read, :attribute_check => true
  filter_access_to [:edit, :update], :require => :update, :attribute_check => true
  filter_access_to [:to_close, :close], :require => :close, :attribute_check => true
  filter_access_to :destroy, :require => :delete, :attribute_check => true
  filter_access_to :reopen, :require => :reopen, :attribute_check => true

  def index
    @projects = []
    unless params[:state].blank?
      @projects = @chair.projects.closed.find(:all)
    else
      @projects = @chair.projects.current_active.find(:all)
    end
  end

  def show
    render :layout => 'project'
  end

  def new
    @project = @chair.projects.build
  end

  def edit
  end

  def create
    @project = @chair.projects.build(params[:project])
    if @project.save
      flash[:notice] = 'Проект успешно создан.'
      redirect_to([@chair, @project])
    else
      render :action => "new"
    end
  end

  def update
    params[:project].delete(:title) unless permitted_to?(:rename, @project)

    if @project.update_attributes(params[:project])
      flash[:notice] = 'Проект успешно обновлён.'
      redirect_to chair_project_url(@project.chair, @project)
    else
      render :action => "edit"
    end
  end

  def to_close
  end

  def close
    begin
      @project.close
      @project.update_attributes!(params[:project])
      @project.disable_modifications
      flash[:notice] = 'Проект успешно закрыт'
      redirect_to(chair_project_url(@chair, @project))
    rescue
      @project.state = @project.state_was
      render :action => :to_close
    end
  end

  def reopen
    @project.reopen
    @project.enable_modifications
    flash[:notice] = 'Проект успешно возобновлен'
    redirect_to(chair_project_url(@chair, @project))
  end

  def destroy
    @project.destroy
    flash[:notice] = 'Проект успешно удален'
    redirect_to chair_projects_url(@chair)
  end

  protected
  def find_chair
    @chair = Chair.find(params[:chair_id])
  end

  def find_project
    @project = @chair.projects.find(params[:id])
  end
end

