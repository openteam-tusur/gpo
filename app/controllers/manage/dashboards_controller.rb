class Manage::DashboardsController < Manage::ApplicationController
  skip_load_and_authorize_resource

  def show
    redirect_to [:manage, current_user.available_chairs.first] unless current_user.manager?
  end
end
