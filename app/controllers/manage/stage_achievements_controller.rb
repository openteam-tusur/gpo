class Manage::StageAchievementsController < Manage::ApplicationController
  load_and_authorize_resource

  def new
    @stage_achievement = Stage.find(params[:stage]).stage_achievements.build
  end

  def create
    @stage_achievement = StageAchievement.new(params[:stage_achievement])
    if @stage_achievement.save
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',
                                                            chair: @stage_achievement.stage.chair.id,
                                                            anchor: "stage_#{@stage_achievement.stage_id}")
    else
      render :action => :new
    end
  end

  def edit
    @stage_achievement = StageAchievement.find(params[:id])
  end

  def update
    @stage_achievement = StageAchievement.find(params[:id])
    if @stage_achievement.update(params[:stage_achievement])
      redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @stage_achievement.stage.chair.id)
    else
      render :action => :edit
    end
  end

  def destroy
    @stage_achievement = StageAchievement.find(params[:id])
    @stage_achievement.destroy
    redirect_to manage_report_edit_chair_attestation_path(report_id: 'chair_attestation',chair: @stage_achievement.stage.chair.id)
  end
end
