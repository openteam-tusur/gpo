# encoding: utf-8

class Manage::ProjectManagersController < Manage::InheritedResourcesController
  belongs_to :chair, :parent_class => Chair do
    belongs_to :project, :optional => true
  end

  actions :all, except: [:show, :destroy]

  layout 'project'

  def index
    index! do
      @project_managers = @project ? collection : @chair.uniq_project_manager_users
      render :layout => 'chair' and return unless @project
    end
  end
end
