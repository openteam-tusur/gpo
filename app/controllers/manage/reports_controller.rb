# encoding: utf-8
require 'better/tempfile'

class Manage::ReportsController < Manage::ApplicationController
  include SendReport

  before_filter :find_chair, :find_project, only: :show

  def index
  end

  def show
    unless params[:format] == 'xls'
      report = Report.new(params[:id], @chair, @project)
    end
    if %w[project_tz chair_statement_checkup].include?(params[:id])
      send_report_throught_jod(report)
    else
      respond_to do |format|
        format.html { render :action => :index }
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
    when 'chair_project_managers_list'
      report = ChairProjectManagersList.new(@chair) if @chair
    when 'chair_schedule_project_managers'
      report = ChairScheduleProjectManagers.new(@chair) if @chair
    when 'chair_attestation'
      report = ChairAttestation.new(@chair) if @chair
    when 'university_participants'
      report = UniversityParticipants.new
    else raise "Нет такого типа xls отчета"
    end

    raise "Неверные параметры для отчета" unless report

    filename = "#{params[:id]}.ods"
    report.render_to_file { |file|
      send_report file, :xls, filename
    }
  end

  private

  def send_report_throught_jod(report)
    report_name = report.id
    template_path = "#{Rails.root}/lib/templates/reports/#{report_name}.odt"

    data_file = Better::Tempfile.open(["data_file", ".xml"]) do |file|
      file << report.model.send("xml_for_#{report_name}")
    end

    extention = Rails::env.production? ? "doc": "odt"

    report_filename = "#{report_name}_#{report.model.id}.#{extention}"
    odt_file = Better::Tempfile.new([report_filename, ".odt"])
    doc_file = Better::Tempfile.new([report_filename, ".doc"])

    libdir = "#{Rails::root}/lib/reports/lib"
    system("java", "-Djava.ext.dir=#{libdir}", "-jar", "#{libdir}/jodreports-2.1-RC.jar", template_path, data_file.path, odt_file.path)
    report_filepath = odt_file.path

    send_report odt_file, :doc, report_filename
  end
end

