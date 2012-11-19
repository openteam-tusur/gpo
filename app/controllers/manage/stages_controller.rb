# encoding: utf-8

class Manage::StagesController < Manage::InheritedResourcesController
  belongs_to :chair, :project

  layout 'project'
end
