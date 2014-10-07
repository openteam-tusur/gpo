# encoding: utf-8

class Manage::StagesController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair do
    belongs_to :project
  end

  layout 'project'
end
