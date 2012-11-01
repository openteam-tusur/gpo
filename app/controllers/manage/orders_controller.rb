# encoding: utf-8

class Manage::OrdersController < Manage::ApplicationController
  inherit_resources
  belongs_to :chair do
    belongs_to :project, optional: true
  end
  actions :all, except: [:new, :create]
  layout 'chair'

  def index
    index! {
      render 'project_orders', layout: 'project' and return if @project
    }
  end

  def show
    super do |format|
      format.html { render :layout => 'order' }
      format.odt { send_odt } if params[:format] == 'odt'
      format.doc { send_converted_odt(:doc) } if params[:format] == 'doc'
    end
  end

  def update
    update do |success, failure|
      success.html { raise 'success'.inspect }
      failure.html { raise 'failure'.inspect }
    end
  end

  def send_odt
    filename = "order_#{@order.id}.odt"
    if @order.file?
      send_file @order.file.to_file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
    else
      @order.generate_odt_file do |file|
        send_file file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
      end
    end
  end

  def send_converted_odt(format)
    filename = "order_#{@order.id}.#{format.to_s}"
    converted_file = Tempfile.new('converted_file')
    if @order.file?
      system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", @order.file.to_file.path, converted_file.path, format.to_s)
      send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
      converted_file.close
    else
      @order.generate_odt_file do |file|
        system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", file.path, converted_file.path, format.to_s)
        send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
        converted_file.close
      end
    end
  end
end
