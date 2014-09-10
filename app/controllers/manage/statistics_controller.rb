class Manage::StatisticsController < Manage::ApplicationController
  def snapshot
    StatisticsSnapshot.build_and_save

    redirect_to manage_statistics_path
  end

  def show
    @chair = Chair.find_by_id(params[:chair_id])
  end
end
