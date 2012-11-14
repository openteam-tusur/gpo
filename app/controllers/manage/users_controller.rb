# encoding: utf-8

class Manage::UsersController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair, optional: true

  actions :all, except: [:show, :new, :create]

  layout :choose_layout

  def choose_layout
    @chair.nil? ? 'application' : 'chair'
  end
end
