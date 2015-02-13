# encoding: utf-8

class Manage::PermissionsController < Manage::InheritedResourcesController

  load_and_authorize_resource

  actions :index, :new, :create, :destroy

  has_scope :page, :default => 1

  def destroy
    destroy! { redirect_to :back and return }
  end

  protected

  def collection
    @permissions = end_of_association_chain.order(created_at: :desc)
  end

end
