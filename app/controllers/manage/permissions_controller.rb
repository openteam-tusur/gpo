# encoding: utf-8

class Manage::PermissionsController < Manage::ApplicationController
  inherit_resources
  actions :all, except: :show

end
