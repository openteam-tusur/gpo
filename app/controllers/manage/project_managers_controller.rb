# encoding: utf-8

class Manage::ProjectManagersController < Manage::InheritedResourcesController
  belongs_to :chair do
    belongs_to :project, optional: true
  end

  actions :all, except: [:show, :destroy]

  layout 'project'

  def index
    index! { render :layout => 'chair' and return unless @project }
  end

end
