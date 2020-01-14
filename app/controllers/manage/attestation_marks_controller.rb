class Manage::AttestationMarksController < Manage::ApplicationController
  load_and_authorize_resource

  def new
    stage = Stage.find(params[:stage])
    @attestation_mark = stage.attestation_marks.build
    @participants = stage.project.participants.active
  end

  def create
    @attestation_mark = AttestationMark.new(params[:attestation_mark])
    @participants = @attestation_mark.stage.project.participants.active
    if @attestation_mark.save
      redirect_to manage_report_edit_chair_attestation_path(
        report_id: 'chair_attestation',
        chair: @attestation_mark.stage.chair.id,
        anchor: @attestation_mark.stage.project.id
      )
    else
      render :action => :new
    end
  end

  def edit
    @attestation_mark = AttestationMark.find(params[:id])
    @participants = @attestation_mark.stage.project.participants.active
  end

  def update
    @attestation_mark = AttestationMark.find(params[:id])
    @participants = @attestation_mark.stage.project.participants.active
    if @attestation_mark.update(params[:attestation_mark])
      redirect_to manage_report_edit_chair_attestation_path(
        report_id: 'chair_attestation',
        chair: @attestation_mark.stage.chair.id,
        anchor: @attestation_mark.stage.project.id
      )
    else
      render :action => :edit
    end
  end

  def destroy
    @attestation_mark = AttestationMark.find(params[:id])
    @attestation_mark.destroy
    redirect_to manage_report_edit_chair_attestation_path(
      report_id: 'chair_attestation',
      chair: @attestation_mark.stage.chair.id,
      anchor: @attestation_mark.stage.project.id
    )
  end
end
