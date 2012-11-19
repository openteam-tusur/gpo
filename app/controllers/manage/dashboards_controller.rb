class Manage::DashboardsController < Manage::ApplicationController
  def show
    redirect_to [:manage, current_user.available_chairs.first] unless current_user.manager?
  end
end
