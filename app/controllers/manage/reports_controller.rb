# encoding: utf-8
require 'better/tempfile'

class Manage::ReportsController < Manage::ApplicationController
  include SendReport

  before_filter :find_chair, :find_project, only: [:show, :preview]

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

  def preview
    if %w[project_tz chair_statement_checkup].include?(params[:id])
      report = Report.new(params[:id], @chair, @project)
    end
    if %w[project_tz chair_statement_checkup].include?(params[:id])
      send_report_throught_jod(report)
    end
    if %w[chair_schedule_group
          chair_schedule_project_managers].include?(params[:id])
      send_xls(params[:id])
    end
  end


  def edit_schedule_group
    find_chair
    @projects = @chair.projects.active
  end

  def edit_schedule_manager
    find_chair
  end

  def edit_chair_attestation
    if params[:reporting_stage].present?
      @chair = Chair.find_by_id(params[:reporting_stage][:chair_id])
      @stages = @chair.projects.map{|p| p.stages.find_by_title(params[:reporting_stage][:title])}.compact
    else
      find_chair
      @stages = @chair.projects.map{|p| p.current_attestation_stage}.compact
    end
    ap @chair
    ap @stages
    if @stages.present?
      @stage_title = @stages.first.title + ' по кафедре ' + @chair.abbr
      @reporting_stage = ReportingStage.find_by_title(@stages.first.title)
    else
      redirect_to manage_chair_path(@chair.id), flash: { error: 'Не найдены этапы промежуточной аттестации' }
    end
  end

  def update_schedule_group
    Project.update(params[:projects].keys, params[:projects].values)
    redirect_to manage_chair_path(params[:chair])
  end

  def update_schedule_manager
    ProjectManager.update(params[:project_managers].keys, params[:project_managers].values)
    redirect_to manage_chair_path(params[:chair])
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
      options = { with_deleted_participants: true, reporting_stage_id: params[:reporting_stage_id]}
      report = ChairAttestation.new(@chair, options) if @chair
    when 'university_participants'
      report = UniversityParticipants.new
    when 'university_projects'
      report = UniversityProjects.new
    else raise "Нет такого типа xls отчета"
    end

    raise "Неверные параметры для отчета" unless report

    report.render_to_file do |file|
      check_converted_format(file, "#{params[:id]}.#{params[:format]}")
    end
  end

  private

  def send_report_throught_jod(report)
    report_name = report.id
    template_path = "#{Rails.root}/lib/templates/reports/#{report_name}.odt"

    data_file = Better::Tempfile.open(["data_file", ".xml"]) do |file|
      file << report.model.send("xml_for_#{report_name}")
    end

    report_filename = "#{report_name}_#{report.model.id}.#{params[:format]}"
    odt_file = Better::Tempfile.new([report_filename, ".odt"])
    doc_file = Better::Tempfile.new([report_filename, ".doc"])

    libdir = "#{Rails::root}/lib/reports/lib"
    system("java", "-Djava.ext.dir=#{libdir}", "-jar", "#{libdir}/jodreports-2.1-RC.jar", template_path, data_file.path, odt_file.path)
    report_filepath = odt_file.path
    check_converted_format(odt_file, report_filename)
  end

  def check_converted_format(file, file_name)
    if params[:format] == 'pdf'
      send_report file, params[:format].to_sym, file_name, 'inline'
    else
      send_report file, params[:format].to_sym, file_name
    end
  end

end
