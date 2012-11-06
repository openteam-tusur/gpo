# encoding: utf-8

class Manage::ChairsController < Manage::ApplicationController
  inherit_resources

  actions :all

  layout 'chair', only: :show

end
