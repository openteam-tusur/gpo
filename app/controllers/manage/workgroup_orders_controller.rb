class Manage::WorkgroupOrdersController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair

  actions :new, :create, :update

  defaults instance_name: 'order'

  layout 'chair'

  def new
    new! {
      render 'manage/orders/new' and return
    }
  end

  def create
    create! do | success, failure |
      success.html { redirect_to manage_chair_order_path(@chair, resource) }
      failure.html { render 'manage/orders/new' }
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to after_order_update_path }
      failure.html { render 'manage/orders/edit' }
    end
  end
end