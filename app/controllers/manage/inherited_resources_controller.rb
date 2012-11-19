class Manage::InheritedResourcesController < Manage::ApplicationController
  inherit_resources
  load_and_authorize_resource

  before_filter :authorize_read_chain, :only => :index
  before_filter :authorize_state_transition, :only => :update

  private

  def authorize_read_chain
    association_chain.each do |object|
      authorize! :read, object
    end
  end

  def authorize_state_transition
    authorize! resource_params.first[:state_event].to_sym, resource if resource_params.first[:state_event]
  end
end

