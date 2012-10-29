# encoding: utf-8

class Manage::GpodaysController < Manage::ApplicationController
  inherit_resources

  actions :all, except: :show
end

