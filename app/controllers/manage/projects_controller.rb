# encoding: utf-8

class Manage::ProjectsController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair

  layout 'chair'

  layout 'project', only: :show


  def to_close
  end

  def close
    begin
      @project.close
      @project.update_attributes!(params[:project])
      @project.disable_modifications
      flash[:notice] = 'Проект успешно закрыт'
      redirect_to(chair_project_path(@chair, @project))
    rescue
      @project.state = @project.state_was
      render :action => :to_close
    end
  end

  def reopen
    @project.reopen
    @project.enable_modifications
    flash[:notice] = 'Проект успешно возобновлен'
    redirect_to(chair_project_path(@chair, @project))
  end
end

