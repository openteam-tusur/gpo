# encoding: utf-8

class Manage::ManagersController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair, :project

  actions :all, except: [:show, :destroy]

  layout 'project'

  def index
    index! {
      @managers.sort!
    }
  end
end
