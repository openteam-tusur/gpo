class Manage::ApplicationController < ApplicationController
  esp_load_and_authorize_resource

  before_filter :authorize_read_chain, :only => :index
  before_filter :authorize_state_transition, :only => :update

  layout 'application'

  private

  def authorize_read_chain
    if respond_to?(:association_chain)
      association_chain.each do |object|
        authorize! :read, object
      end
    end
  end

  def authorize_state_transition
    authorize! resource_params.first[:state_event].to_sym, resource if resource_params.first[:state_event]
  end

  def after_order_update_path
    resource.removed? ? manage_chair_orders_path(@chair) : manage_chair_order_path(@chair, resource)
  end

end
