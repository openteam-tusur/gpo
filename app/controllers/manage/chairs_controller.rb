# encoding: utf-8

class Manage::ChairsController < Manage::ApplicationController
  inherit_resources

  actions :all

  has_scope :ordered_by_title, :only => :index, :default => true, :type => :boolean

  layout 'chair', only: :show

end
