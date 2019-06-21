class Manage::InternationalReportsController < Manage::ApplicationController
  def new
    @international_report = Stage.find(params[:stage]).international_reports.build(participant_id: params[:participant])
  end

  def create
    @international_report = InternationalReport.new(params[:international_report])
    if @international_report.save
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @international_report.stage.chair.id)
    else
      render :action => :new
    end
  end

  def edit
    @international_report = InternationalReport.find(params[:id])
  end

  def update
    @international_report = InternationalReport.find(params[:id])
    if @international_report.update(params[:international_report])
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @international_report.stage.chair.id)
    else
      render :action => :edit
    end
  end

  def destroy
    @international_report = InternationalReport.find(params[:id])
    @international_report.destroy
    redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @international_report.stage.chair.id)
  end
end
