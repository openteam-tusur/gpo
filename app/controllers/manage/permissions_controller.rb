# encoding: utf-8

class Manage::PermissionsController < Manage::InheritedResourcesController
  actions :all, except: :show
end
