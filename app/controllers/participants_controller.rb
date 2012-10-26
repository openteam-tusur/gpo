# encoding: utf-8

class ParticipantsController < ApplicationController
  before_filter :find_project
  before_filter :find_students, :only => [:new, :create]
  before_filter :find_participant, :except => [:index, :new, :create]
  before_filter :prepare_participant, :only => [:new, :create]
  layout 'project'
  
  def index
#    authorize can_list?(Participant, @project)
    @participants = @project.participants.find(:all)
  end

  def new
#    authorize can_create?(@participant)
  end

  def create
#    permitted_to!(:create, @participant)
#    authorize can_create?(@participant)
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
#    authorize @participant.can_send_cancel?(current_user)
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
#    authorize @participant.can_send_approve?(current_user)
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
#    authorize can_destroy?(@participant)
    
    if @participant.remove
      flash[:notice] = "Участник помечен на удаление"
    end
    redirect_to chair_project_participants_path(@project.chair, @project)
  end
  
  protected
  def find_project
    @project = Project.find(params[:project_id])
  end
  
  def find_participant
    @participant = @project.participants.find(params[:id])
  end
  
  def prepare_participant
    @participant = @project.participants.build(params[:participant])
  end

  def find_students
    @students = []
    @query = Hash.new
    if params.has_key?("commit")
      @query[:last_name] = params[:last_name].strip unless params[:last_name].blank?
      @query[:edu_group] = params[:edu_group].strip unless params[:edu_group].blank?
      if @query.empty?
        flash[:error] = "Не указаны параметры поиска"
      else
        @students = Student.find(:all, :params => @query) unless @query.empty?
        @participants = []
        @students.each do |student|
          participant = Participant.find_by_student_id(student.id) || 
            @project.participants.build(:student_id => student.id, 
            :last_name => student.last_name, 
            :first_name => student.first_name, 
            :mid_name => student.mid_name,
            :edu_group => student.edu_group,
            :course => student.course)
   #       participant.project = @project if participant.new_record?
          @participants << participant
        end
      end
    end
  end
  
end
