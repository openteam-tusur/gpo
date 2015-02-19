class Manage::DashboardsController < Manage::ApplicationController
  load_and_authorize_resource :class => false
  def show
    redirect_to [:manage, current_user.project.chair, current_user.project] and return if current_user.executive_participant?
    redirect_to [:manage, current_user.available_chairs.first] and return unless current_user.manager?
  end
end
