class ReportsController < ApplicationController
  before_filter [:find_chair, :find_project], :only => :show
  filter_access_to :all
  filter_access_to :show do
    permitted_to!(:read, @chair) if @chair
    permitted_to!(:read, @project) if @project
    permitted_to!(:read, :reports) if @project.nil? && @chair.nil?
    true
  end

  def index
  end

  def show
    unless params[:format] == 'xls'
      report = Report.new(params[:id], @chair, @project)
    end
    if params[:id] == "project_tz"
      send_report_throught_jod(report)
    else
      respond_to do |format|
        format.html { render :action => :index }
        format.odt { send_odt(report) } if params[:format] == 'odt'
        format.doc { send_converted_odt(report, :doc) } if params[:format] == 'doc'
        format.xls { send_xls(params[:id]) } if params[:format] == 'xls'
      end
    end
  end

  protected

  def find_chair
    @chair = Chair.find_by_id(params[:chair])
  end

  def find_project
    @project = Project.find_by_id(params[:project])
  end

  def send_xls(report)
    case params[:id]
    when 'chair_schedule_group'
      report = ChairScheduleGroup.new(@chair) if @chair
    when 'chair_projects_list'
      report = ChairProjectsList.new(@chair) if @chair
    when 'chair_projects_stat'
      report = ChairProjectsStat.new(@chair) if @chair
    when 'chair_managers_list'
      report = ChairManagersList.new(@chair) if @chair
    when 'chair_schedule_managers'
      report = ChairScheduleManagers.new(@chair) if @chair
    when 'chair_attestation'
      report = ChairAttestation.new(@chair) if @chair
    when 'university_participants'
      report = UniversityParticipants.new
    else raise "Нет такого типа xls отчета"
    end

    raise "Неверные параметры для отчета" unless report

    filename = "#{params[:id]}.xls"
    report.render_to_file { |file|
      converted_file = Tempfile.new('converted_file')
      system("bash", "#{RAILS_ROOT}/script/converter/converter_xls.sh", file.path, converted_file.path, "xls")
      send_file converted_file.path, :type => Mime::Type.lookup_by_extension('xls'), :filename => filename
    }
  end

  def send_odt(report)
    filename = "#{report.id}.odt"
    ReportPrinter.render_to_file(report) { |file|
      send_file file.path, :type => Mime::Type.lookup_by_extension('odt'), :filename => filename
    }
  end

  def send_converted_odt(report, format)
    filename = "#{report.id}.#{format.to_s}"
    ReportPrinter.render_to_file(report) { |file|
      converted_file = Tempfile.new('converted_file')
      system("bash", "#{RAILS_ROOT}/script/converter/converter.sh", file.path, converted_file.path, format.to_s)
      send_file converted_file.path, :type => Mime::Type.lookup_by_extension(format.to_s), :filename => filename
    }
  end

  private
  def send_report_throught_jod(report)
    report_name = report.id
    template_path = "#{Rails.root}/lib/templates/reports/#{report_name}.odt"

    data_file = Better::Tempfile.open(["data_file", ".xml"]) do |file|
      file << report.model.to_tz_report
    end

    extention = "doc" #Rails::env.production? ? "doc": "odt"

    report_filename = "#{report_name}_#{report.model.id}.#{extention}"
    odt_file = Better::Tempfile.new([report_filename, ".odt"])
    doc_file = Better::Tempfile.new([report_filename, ".doc"])

    libdir = "#{Rails::root}/lib/templates/reports/lib"
    system("java", "-Djava.ext.dir=#{libdir}", "-jar", "#{libdir}/jodreports-2.1-RC.jar", template_path, data_file.path, odt_file.path)
    report_filepath = odt_file.path

    if extention == "doc"
      system("java", "-Djava.ext.dir=#{libdir}", "-jar", "#{libdir}/jodconverter-cli-2.2.2.jar", odt_file.path, doc_file.path)
      report_filepath = doc_file.path
    end

    send_file report_filepath, :type => MIME::Types.of(extention).first.content_type, :filename => report_filename
  end
end

