class Manage::ChairProjectsHistoryController < Manage::ApplicationController
  def show
    @project = Project.find(params[:id])
    @participants = @project.participants.order(:created_at)
    @deleted_participants = @project.participants.with_deleted.where.not(deleted_at: nil).order(:deleted_at)
  end

  def index
    @projects = Chair.find(params[:chair]).projects
  end
end
