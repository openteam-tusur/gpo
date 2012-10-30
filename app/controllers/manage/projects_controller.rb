# encoding: utf-8

class Manage::ProjectsController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair

  custom_actions resource: [:to_close, :close]

  layout 'chair'

  layout 'project', only: :show

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
end

