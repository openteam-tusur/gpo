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

  def send_odt
    filename = "order_#{@order.id}.odt"

    zip = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{@order.class.name.underscore}.odt")
    erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", @order.class.name.underscore, "content.xml"))

    t = Tempfile.new("my-temp-filename-#{Time.now}")

    Zip::ZipOutputStream.open(t.path) do |z|
      zip.each do |entry|
        z.put_next_entry entry.name
        if entry.name == 'content.xml'
          z.write erb.result(binding)
        else
          z.print zip.read(entry.name)
        end
      end
    end

    #TODO: Не генерить файлик, если он есть на файловой системе
    send_file t.path, :type => 'application/zip', :disposition => 'attachment', :filename => filename

    t.unlink
    zip.close
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
