class Manage::ApplicationController < ApplicationController
  def after_order_update_path
    resource.removed? ? manage_chair_orders_path(@chair) : manage_chair_order_path(@chair, resource)
  end
end
