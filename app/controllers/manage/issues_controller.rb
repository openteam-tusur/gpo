# encoding: utf-8

class Manage::IssuesController < Manage::InheritedResourcesController
  include SendReport

  layout 'project'

  belongs_to :chair, :parent_class => Chair do
    belongs_to :project do
      belongs_to :participant, :optional => true
    end
  end

  actions :all, :except => :show
  custom_actions :collection => :export

  def export
    export!{
      ParticipantIssues.new(@participant).render_to_file { |file|
        send_report file, :xls, 'issues.xls'
      }
      return
    }
  end

  def create
    create! do |success, failure|
      success.html {
        flash[:notice] = "Индивидуальная задача для студента добавлена"
        redirect_to manage_chair_project_issues_path(@chair, @project)
      }
      failure.html {
        flash[:error] = "Ошибка добавления задачи"
        render :action => :new
      }
    end
  end

  def update
    update! do |success, failure|
      success.html {
        flash[:notice] = "Индивидуальная задача для студента сохранена"
        redirect_to manage_chair_project_issues_path(@chair, @project)
      }
      failure.html {
        flash[:error] = "Ошибка сохранения задачи"
        render :action => :edit
      }
    end
  end

  def destroy
    destroy! do |success, failure|
      success.html {
        flash[:notice] = "Индивидуальная задача для участника удалена"
        redirect_to manage_chair_project_issues_path(@chair, @project)
      }
      failure.html {
        flash[:notice] = "Ошибка при удалении задачи"
        redirect_to manage_chair_project_issues_path(@chair, @project)
      }
    end
  end
end
