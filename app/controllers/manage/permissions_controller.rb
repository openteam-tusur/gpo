# encoding: utf-8

class Manage::PermissionsController < Manage::InheritedResourcesController
  load_and_authorize_resource
  actions :index, :new, :create, :destroy
end
