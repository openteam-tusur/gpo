# encoding: utf-8

class Manage::ProjectsController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair

  custom_actions resource: [:to_close, :close]

  layout :choose_layout

  has_scope :filtered_by_state, :default => true, :type => :boolean, :only => :index do |controller, scope|
     controller.params[:state] == 'close' ? scope.closed : scope.current_active
  end

  has_scope :authorized_projects, :default => true, :type => :boolean, :only => :index do |controller, scope|
    scope.for_user(controller.send(:current_user))
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
      @project.reopen!
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

