# encoding: utf-8
require 'zip/zip'

class Manage::OrdersController < Manage::ApplicationController
  include SendReport
  inherit_resources

  layout 'chair'

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
    super do |format|
      format.html { render :layout => 'order' }
      format.odt { send_odt } if params[:format] == 'odt'
      format.doc { send_converted_odt(:doc) } if params[:format] == 'doc'
    end
  end

  def destroy
    show! {
      @order.remove
      flash[:notice] = 'Приказ успешно удален'

      redirect_to collection_url and return
    }
  end

  #TODO: Не генерить файлик, если он есть на файловой системе
  def send_odt
    filename = "order_#{@order.id}.odt"
    generated_odt = generate_odt
    send_file generated_odt.path, :type => 'application/zip', :disposition => 'attachment', :filename => filename
    generated_odt.unlink
  end

  #TODO: Не конвертировать, если есть на файловой системе
  def send_converted_odt(format)
    filename = "order_#{@order.id}.doc"
    generated_odt = generate_odt
    send_report generated_odt.path, :doc, filename
    generated_odt.unlink
  end

  private
    def generate_odt
      zip = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{@order.class.name.underscore}.odt")
      erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", @order.class.name.underscore, "content.xml"))

      generated_odt = Tempfile.new("my-temp-filename-#{Time.now}")

      Zip::ZipOutputStream.open(generated_odt.path) do |z|
        zip.each do |entry|
          z.put_next_entry entry.name
          if entry.name == 'content.xml'
            z.write erb.result(binding)
          else
            z.print zip.read(entry.name)
          end
        end
      end

      generated_odt
    end
end
