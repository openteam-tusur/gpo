class Manage::StudentAchievementsController < Manage::ApplicationController
  load_and_authorize_resource

  def new
    @student_achievement = Stage.find(params[:stage]).student_achievements.build(participant_id: params[:participant])
  end

  def create
    @student_achievement = StudentAchievement.new(params[:student_achievement])
    if @student_achievement.save
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @student_achievement.stage.chair.id)
    else
      render :action => :new
    end
  end

  def edit
    @student_achievement = StudentAchievement.find(params[:id])
  end

  def update
    @student_achievement = StudentAchievement.find(params[:id])
    if @student_achievement.update(params[:student_achievement])
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @student_achievement.stage.chair.id)
    else
      render :action => :edit
    end
  end

  def destroy
    @student_achievement = StudentAchievement.find(params[:id])
    @student_achievement.destroy
    redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @student_achievement.stage.chair.id)
  end
end
