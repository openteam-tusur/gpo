# encoding: utf-8

class Manage::GpodaysController < Manage::InheritedResourcesController
  actions :all, except: :show
end

