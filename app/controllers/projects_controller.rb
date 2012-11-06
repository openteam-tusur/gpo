# encoding: utf-8

class ProjectsController < ApplicationController
  inherit_resources

  belongs_to :chair

  actions :index, :show

  def index
    index! {
      @projects = @chair.projects.current_active
    }
  end
end
