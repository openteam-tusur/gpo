class Manage::StudentAchievementsController < Manage::ApplicationController
  load_and_authorize_resource

  def new
    stage = Stage.find(params[:stage])
    @student_achievement = stage.student_achievements.build
    @participants = stage.project.participants.active
  end

  def create
    @student_achievement = StudentAchievement.new(params[:student_achievement])
    @participants = @student_achievement.stage.project.participants.active
    @student_achievement.participant_ids = params[:student_achievement][:participant_ids]
    if @student_achievement.save
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',
                                                            chair: @student_achievement.stage.chair.id,
                                                            anchor: "stage_#{@student_achievement.stage_id}")
    else
      render :action => :new
    end
  end

  def edit
    @student_achievement = StudentAchievement.find(params[:id])
    @participants = @student_achievement.stage.project.participants.active
  end

  def update
    #create update add @participants
    @student_achievement = StudentAchievement.find(params[:id])
    @participants = @student_achievement.stage.project.participants.active
    @student_achievement.participant_ids = params[:student_achievement][:participant_ids]
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
