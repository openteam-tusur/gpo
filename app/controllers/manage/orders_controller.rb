# encoding: utf-8

class Manage::OrdersController < Manage::ApplicationController
  include GenerateOdt
  include SendReport
  inherit_resources

  layout 'chair'

  respond_to :html, :doc

  belongs_to :chair do
    belongs_to :project, optional: true
  end

  actions :all, except: [:new, :create, :update]

  def index
    index! {
      render 'project_orders', layout: 'project' and return if @project
    }
  end

  def show
    show! { |format|
      format.html { render :layout => 'order' }
      format.doc  { send_converted_odt(:doc) and return }
    }
  end

  def destroy
    show! {
      @order.remove
      flash[:notice] = 'Приказ успешно удален'

      redirect_to collection_url and return
    }
  end

  private
    def send_converted_odt(format)
      filename = "order_#{@order.id}.doc"
      generated_odt = generate_odt(@order)
      send_report generated_odt.path, :doc, filename
      generated_odt.unlink
    end
end
