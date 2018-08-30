# encoding: utf-8

class Manage::OrdersController < Manage::InheritedResourcesController
  include SendReport

  layout 'chair'

  respond_to :html, :doc

  belongs_to :chair, :parent_class => Chair do
    belongs_to :project, optional: true
  end

  actions :show, :index, :edit, :destroy

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

  def preview
    open(@order.file.url) {|f| send_report f, :pdf, "#{@order.id}_preview.pdf", 'inline' }
  rescue
    raise ActionController::RoutingError.new('Not Found')
  end

  private
    def send_converted_odt(format)
      @order.generate_odt do |generated_odt|
        send_report generated_odt, :doc
      end
    end
end
