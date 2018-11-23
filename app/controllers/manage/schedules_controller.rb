class Manage::SchedulesController < ApplicationController
  before_action :find_chair
  before_action :find_schedule, only: [:edit, :update, :destroy]

  layout 'chair', only: :show

  def index
    @schedules = Schedule.all
  end

  def new
    @schedule = Schedule.new
  end

  def edit
    if @schedule.schedule_type.project_managers?
      @project_managers = @chair.project_manager_users
    end
  end

  def create
    @schedule = Schedule.new(schedule_type: params[:schedule][:schedule_type], chair_id: @chair.id)

    if @schedule.save
      redirect_to manage_chair_schedules_path(@chair)
    else
      render 'new'
    end
  end

  private

  def find_chair
    @chair = Chair.find(params[:chair_id])
  end

  def find_schedule
    @schedule = Schedule.find(params[:id])
  end
end
