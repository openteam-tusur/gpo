# encoding: utf-8

class Manage::OrdersController < Manage::ApplicationController
  inherit_resources

  belongs_to :chair do
    belongs_to :project, optional: true
  end

  actions :all, except: [:new, :create, :update]

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

  def send_odt
    filename = "order_#{@order.id}.odt"
    #zip = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{@order.class.name.underscore}.odt")
    #erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", @order.class.name.underscore, "content.xml"))
    #odt_file = Tempfile.new("my-temp-filename-#{Time.now}")
    #Zip::ZipOutputStream.open(odt_file.path) do |out|
      #zip.each do |entry|
        #out.put_next_entry entry.name
        #out.print zip.read(entry.name)
      #end
    #end
    #zip.close
    #send_data odt_file, :filename => filename
    #return
    #odt.get_output_stream("content.xml").write file.write erb.result(binding)
    #odt.close

    TempDir.create do |dir|
      system("unzip #{Rails.root}/lib/templates/reports/#{@order.class.name.underscore}.odt > /dev/null")
      erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", @order.class.name.underscore, "content.xml"))
      File.open("content.xml", "w") do | file |  file.write erb.result(binding)  end
      send_data `zip -r - .`,
        :filename => filename
    end

    #if @order.file?
      #send_file @order.file.to_file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
    #else
      #@order.generate_odt_file do |file|
        #send_file file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
      #end
    #end
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
