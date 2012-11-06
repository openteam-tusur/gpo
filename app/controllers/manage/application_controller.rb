class Manage::ApplicationController < ApplicationController
  before_filter :find_user_chairs

  def after_order_update_path
    resource.removed? ? manage_chair_orders_path(@chair) : manage_chair_order_path(@chair, resource)
  end

  def dashboard
    @chair = @user_chairs.first
    redirect_to manage_chair_path(@chair)
  end

  protected

  def find_user_chairs
    @user_chairs = Chair.all
  end
end
