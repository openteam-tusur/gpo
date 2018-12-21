desc 'Обновить участников промежуточной аттестации'

task :update_reporting_marks, [:rs_id] => :environment do |t, args|
  abort 'Укажите идентификатор этапа промежуточной аттестации' if args.empty?
  reporting_stage = ReportingStage.find(args['rs_id'])
  abort 'Этап аттестации не найден' if reporting_stage.nil?
  Project.active.find_each do |project|
    stage = project.stages.find_by_reporting_stage_id(args['rs_id'])
    if stage.present?
      project.participants.active.each do |participant|
        if stage.reporting_marks.find_by_contingent_id(participant.student_id).nil?
          ap 'Проект ' + project.cipher + ' добавляется ' + participant.name + ' student_id: ' + participant.student_id.to_s
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
      stage.reporting_marks.each do |rm|
        if project.participants.active.find_by_student_id(rm.contingent_id).nil? && rm.mark == nil
          ap 'Проект ' + project.cipher + ' удаляется ' + rm.fullname + ' student_id: ' + rm.contingent_id.to_s
          rm.destroy
        end
      end
    end
  end
end
