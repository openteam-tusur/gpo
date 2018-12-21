desc 'Добавить этап промежуточной аттестации, в проекты, где он отсутствует'

task :set_reporting_stages, [:rs_id] => :environment do |t, args|
  abort 'Укажите идентификатор этапа промежуточной аттестации' if args.empty?
  reporting_stage = ReportingStage.find(args['rs_id'])
  abort 'Этап аттестации не найден' if reporting_stage.nil?
  Project.active.find_each do |project|
    if project.stages.where(reporting_stage_id: args['rs_id']).empty?
      ap 'Проект ' + project.cipher + ' id: ' + project.id.to_s
      stage = project.stages.create!(
        title: reporting_stage.title,
        start: reporting_stage.start,
        finish: reporting_stage.finish,
        reporting_stage: reporting_stage,
        skip_validation: true
      )
      ap 'Добавлен этап: ' + stage.title + ' id: ' + stage.id.to_s
      project.participants.active.each do |participant|
        stage.reporting_marks.create(
          fullname: [
            participant.last_name,
            participant.first_name,
            participant.middle_name
          ].delete_if(&:blank?).join(' ').squish,
          group: participant.edu_group,
          course: participant.course,
          faculty: participant.faculty,
          subfaculty: participant.subfaculty,
          contingent_id: participant.student_id,
          mark: nil,
          skip_validation: true
        )
      end
    end
  end
end
