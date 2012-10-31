# encoding: utf-8

class Manage::ProjectsController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair

  custom_actions resource: [:to_close, :close]

  layout :choose_layout

  def index
    index! {
      @projects = @chair.projects.current_active
      @projects = @chair.projects.closed unless params[:state].blank?
    }
  end

  def close
    update! {
      if @project.close
        flash[:notice] = 'Проект успешно закрыт'

        redirect_to manage_chair_project_path(@chair, @project) and return

      else
        render :action => :to_close and return
      end
    }
  end

  def reopen
    show! {
      @project.reopen
      flash[:notice] = 'Проект успешно возобновлен'

      redirect_to manage_chair_project_path(@chair, @project) and return
    }
  end

  private

  def choose_layout
    return 'project' if %w[show].include? params[:action]
    'chair'
  end
end

