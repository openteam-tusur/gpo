class StagesController < ApplicationController
  before_filter :find_project
  filter_access_to :all
  filter_access_to [:index, :show], :require => :read, :context => :projects, :attribute_check => true
  filter_access_to [:new, :create, :edit, :update, :destroy], :require => :update, :context => :projects, :attribute_check => true
  layout 'project'

  def index
    @stages = @project.stages
  end

  # GET /stages/1
  # GET /stages/1.xml
  def show
    @stage = Stage.find(params[:id])
#    authorize can_view?(@stage)
  end

  # GET /stages/new
  # GET /stages/new.xml
  def new
    @stage = @project.stages.build
#    authorize can_create?(@stage)
  end

  # GET /stages/1/edit
  def edit
    @stage = @project.stages.find(params[:id])
#    authorize can_update?(@stage)
  end

  # POST /stages
  # POST /stages.xml
  def create
    @stage = @project.stages.build(params[:stage])
#    authorize can_create?(@stage)
    
    if @stage.save
      flash[:notice] = 'Этап успешно создан.'
      redirect_to chair_project_stage_url(@project.chair, @project, @stage)
    else
      render :action => "new"
    end
  end

  # PUT /stages/1
  # PUT /stages/1.xml
  def update
    @stage = @project.stages.find(params[:id])
#   authorize can_update?(@stage)
    
    if @stage.update_attributes(params[:stage])
      flash[:notice] = 'Этап успешно сохранен.'
      redirect_to chair_project_stage_url(@project.chair, @project, @stage)
    else
      render :action => "edit"
    end
  end

  # DELETE /stages/1
  # DELETE /stages/1.xml
  def destroy
    @stage = @project.stages.find(params[:id])
#    authorize can_destroy?(@stage)
    
    @stage.destroy

    flash[:notice] = 'Этап успешно удален.'
    redirect_to chair_project_stages_url(@project.chair, @project)
  end

  private
  def find_project
    @project = Project.find(params[:project_id])
  end
end
