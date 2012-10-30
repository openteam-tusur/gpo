# encoding: utf-8

class Manage::StagesController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair, :project

  layout 'project'
end
