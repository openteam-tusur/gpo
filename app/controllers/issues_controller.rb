class IssuesController < ApplicationController
  layout 'project'

  before_filter :find_project
  before_filter :find_participant, :except => [:index]
  before_filter :find_issue, :only => [:edit, :update, :destroy]

  filter_access_to :all, :require => :read, :context => :projects, :attribute_check => true
  filter_access_to [:new, :edit, :create, :update, :destroy], :require => :update, :context => :projects, :attribute_check => true

  def index
  end

  def new
    @issue = @participant.issues.new
  end

  def edit
  end

  def export
    ParticipantIssues.new(@participant).render_to_file { |file|
      converted_file = Tempfile.new('converted_file')
      system("bash", "#{RAILS_ROOT}/script/converter/converter_xls.sh", file.path, converted_file.path, "xls")
      send_file converted_file.path, :type => Mime::Type.lookup_by_extension('xls'), :filename => "issues.xls"
    }
  end

  def create
    @issue = @participant.issues.new(params[:issue])
    if @issue.save
      flash[:notice] = "Индивидуальная задача для студента добавлена"
      redirect_to chair_project_issues_path(@chair, @project)
    else
      flash[:error] = "Ошибка добавления задачи"
      render :action => :new
    end
  end

  def update
    if @issue.update_attributes(params[:issue])
      flash[:notice] = "Индивидуальная задача для студента сохранена"
      redirect_to chair_project_issues_path(@chair, @project)
    else
      flash[:error] = "Ошибка сохранения задачи"
      render :action => :edit
    end
  end

  def destroy
    @issue.destroy
    flash[:notice] = "Индивидуальная задача для участника удалена"
    redirect_to chair_project_issues_path(@chair, @project)
  end

  protected

  def find_project
    @project = Project.find(params[:project_id])
    @chair = @project.chair
  end

  def find_participant
    @participant = @project.participants.find(params[:participant_id])
  end

  def find_issue
    @issue = @participant.issues.find(params[:id])
  end
end
