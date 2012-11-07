class Manage::ApplicationController < ApplicationController
  #esp_load_and_authorize_resource
  layout 'application'

  private

  def after_order_update_path
    resource.removed? ? manage_chair_orders_path(@chair) : manage_chair_order_path(@chair, resource)
  end

end
