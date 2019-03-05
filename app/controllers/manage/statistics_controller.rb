require 'csv'

class Manage::StatisticsController < Manage::ApplicationController
  def snapshot
    StatisticsSnapshot.build_and_save

    redirect_to manage_statistics_path
  end

  def destroy
    @statistic = StatisticsSnapshot.find(params[:id])
    @statistic.destroy
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
    respond_to do |format|
      format.html
      format.csv {
        csv_content = CSV.generate do |csv|
          csv << ['Показатель', 'Текущая статистика'] + @statistics.map(&:created_at).map {|date| I18n.l(date, :format => '%d.%m.%Y')}
          @indicators.each_with_index do |indicator, index|
            values = []
            @statistics.each do |statistic|
              indicator_value = if @chair
                                  if statistic.data[@chair.id].present?
                                    statistic.data[@chair.id][indicator]
                                  else
                                    '0'
                                  end
                                else
                                  statistic.data[:global][indicator]
                                end
              values << indicator_value
            end
            csv << [I18n.t("statistics.#{indicator}"), @current_statistics[index].value] + values
          end
        end
        send_data csv_content
      }
    end
  end
end
