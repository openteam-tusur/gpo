# encoding: utf-8

class Manage::ManagersController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair do
    belongs_to :project, optional: true
  end

  actions :all, except: [:show, :destroy]

  layout 'project'

  def index
    index! {
      @managers.sort!
      render :layout => 'chair' and return unless @project
    }
  end

end
