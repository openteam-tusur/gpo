# encoding: utf-8

class Manage::ParticipantsController < Manage::ApplicationController
  before_filter :find_project
  before_filter :find_students, :only => [:new, :create]
  before_filter :find_participant, :except => [:index, :new, :create]
  before_filter :prepare_participant, :only => [:new, :create]

  layout 'project'

  def index
    @participants = @project.participants.find(:all)
  end

  def new
  end

  def create
    participant = Participant.find_by_student_id(@participant.student_id)
    if !participant.nil? && participant.project.eql?(@project)
      participant.cancel
      flash[:notice] = "Исключение участника отменено"
      redirect_to chair_project_participants_path(@project.chair, @project)
      return
    end
    if @participant.save
      flash[:notice] = 'Добавлен новый участник'
      redirect_to chair_project_participants_path(@project.chair, @project)
    else
      render :action => "new"
    end
  end

  def cancel
    awaiting_approval = @participant.awaiting_approval?
    if @participant.cancel
      if awaiting_approval
        flash[:notice] = "Включение нового участника отменено"
      else
        flash[:notice] = "Исключение участника отменено"
      end
    end
    redirect_to chair_project_participants_path(@project.chair, @project)
  end

  def approve
    awaiting_approval = @participant.awaiting_approval?
    if @participant.approve
      if awaiting_approval
        flash[:notice] = "Включение нового участника подтверждено"
      else
        flash[:notice] = "Исключение участника подтверждено"
      end
    end
    redirect_to chair_project_participants_path(@project.chair, @project)
  end

  def destroy
    if @participant.remove
      flash[:notice] = "Участник помечен на удаление"
    end
    redirect_to chair_project_participants_path(@project.chair, @project)
  end

  protected

  def find_project
    @project = Project.find(params[:project_id])
    @chair = @project.chair
  end

  def find_participant
    @participant = @project.participants.find(params[:id])
  end

  def prepare_participant
    @participant = @project.participants.build(params[:participant])
  end

  def find_students
    @participants = Participant.contingent_find(params[:search] || {}, @project)
  end

end
