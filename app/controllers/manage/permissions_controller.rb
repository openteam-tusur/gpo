# encoding: utf-8

class Manage::PermissionsController < Manage::InheritedResourcesController

  load_and_authorize_resource

  actions :index, :new, :create, :destroy

  has_scope :page, :default => 1

  protected

  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.paginate(:page => params[:page]))
  end

end
