class Manage::StatisticsController < Manage::ApplicationController
  def snapshot
    StatisticsSnapshot.build_and_save

    redirect_to manage_statistics_path
  end

  def show
    @chairs = Chair.ordered_by_abbr
    @chair = Chair.find_by_id(params[:chair_id])
    @current_statistics = if @chair
                Stat.for_chair(@chair)
              else
                Stat.global
              end
    @statistics = StatisticsSnapshot.order('created_at desc')
    @indicators = @current_statistics.map(&:key)
    @dates = @statistics.map(&:created_at)
  end
end
