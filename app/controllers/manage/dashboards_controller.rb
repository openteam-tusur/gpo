class Manage::DashboardsController < Manage::ApplicationController
  load_and_authorize_resource :class => false
  def show
    redirect_to [:manage, current_user.available_chairs.first] unless current_user.manager?
  end
end
