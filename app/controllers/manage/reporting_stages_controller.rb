# encoding: utf-8

class Manage::ReportingStagesController < Manage::InheritedResourcesController
  actions :all, except: :show
end

