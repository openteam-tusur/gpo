require 'progress_bar'

desc 'Remove doubles of visitations'
task clear_visitations: :environment do
  ap 'Собираем дубли'
  pb = ProgressBar.new(Visitation.count)
  have_doubles = []
  Visitation.find_each do |visitation|
    have_doubles << visitation if Visitation.where(
      gpoday_id: visitation.gpoday_id,
      participant_id: visitation.participant_id
    ).count > 1
    pb.increment!
  end

  ap %(Найдено: #{have_doubles.count})

  if have_doubles.any?
    ap 'Очищаем дубли'
    pb = ProgressBar.new(have_doubles.count)
    have_doubles.each do |visitation|
      visitations = Visitation.where(
        gpoday_id: visitation.gpoday_id,
        participant_id: visitation.participant_id
      ).order(:created_at)
      visitations.last(visitations.count - 1).map(&:destroy)
      pb.increment!
    end
  end
end
