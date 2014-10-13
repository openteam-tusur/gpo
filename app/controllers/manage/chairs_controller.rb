# encoding: utf-8

class Manage::ChairsController < Manage::InheritedResourcesController
  actions :all

  has_scope :ordered_by_title, :only => :index, :default => true, :type => :boolean
  has_scope :viewable, :default => true, :type => :boolean do |controller, scope|
    controller.current_user.available_chairs
  end

  layout 'chair', only: :show

end
