# encoding: utf-8

class ProjectsController < ApplicationController
  inherit_resources

  belongs_to :chair

  actions :index, :show

  has_scope :current_active, default: true, type: :boolean
  has_scope :with_participants, default: true, type: :boolean
end
