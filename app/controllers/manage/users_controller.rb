# encoding: utf-8

class Manage::UsersController < Manage::ApplicationController
  inherit_resources
  actions :all, except: [:show, :new, :create]

  belongs_to :chair, optional: true

  layout :choose_layout

  def choose_layout
    @chair.nil? ? 'application' : 'chair'
  end
end
