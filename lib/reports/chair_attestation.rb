# encoding: utf-8
class ChairAttestation < XlsReport
  attr_accessor :chair, :options, :reporting_stage

  def initialize chair, options = {}
    @chair = chair
    @options = options
    set_reporting_stage
  end

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("CHAIR_ABBR", @chair.abbr).
              gsub("SEMESTR", @reporting_stage.declension_kind_of_semester).
              gsub("EDU_EAYR", @reporting_stage.year_of_title).
              gsub("GPO_CHIEF", chair.mentors[0].initials_name).
              gsub("CHAIR_CHIEF", chair.chief).
              gsub("C_YEAR", self.c_year)
    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[7]')
    formula_index = 7
    participant_index = 0

    filtered_projects(chair).each do |project|
      i = 1
      participants_collection  = project.participants.active
      participants_collection += filtered_deleted_participants(project) if options[:with_deleted_participants]
      participants_collection.uniq.each do |participant|
        tmp_row = row.deep_clone

        # deep_clone не всегда deep :(
        # поэтому используем этот хитрый хак, чтобы формулы прокопировались правильно
        tmp_row.elements[8].attributes.inspect
        tmp_row.elements[9].attributes.inspect
        tmp_row.elements[10].attributes.inspect
        tmp_row.elements[11].attributes.inspect

        if i == 1
          tmp_row.elements[1].add_attributes({"table:number-rows-spanned" => participants_collection.size.to_s})
          tmp_row.elements[2].add_attributes({"table:number-rows-spanned" => participants_collection.size.to_s})
          tmp_row.elements[3].add_attributes({"table:number-rows-spanned" => participants_collection.size.to_s})
        end
        tmp_row.elements[1][1].text = "#{project.cipher} #{project.title} #{project.people.collect {|person| person}.join(", ")}"

        #tmp_row.elements[2][1].text = stage_achievements(project, participant, :grants)
        #tmp_row.elements[3][1].text = stage_achievements(project, participant, :exhibitions)
        stage = ReportingStage.find_by(id: @reporting_stage.id).stages.where(project_id: project.id).last
        tmp_row.elements[2][1].text = stage.grants.map{ |g| g.title }.join(', ')
        tmp_row.elements[3][1].text = stage.exhibitions.map{ |e| e.title }.join(', ')

        tmp_row.elements[4][1].text = i
        tmp_row.elements[5][1].text = detected_participant_name(participant)
        tmp_row.elements[6][1].text = participant.course
        tmp_row.elements[7][1].text = participant.edu_group
        tmp_row.elements[8][1].text = participant.total_term_mark
        tmp_row.elements[8].attributes['value'].gsub!("0", participant.total_term_mark.round.to_s)

        attestation_mark = project.
                           current_attestation_stage.
                           try(:attestation_marks).
                           try(:find_by, participant_id: participant)
        if attestation_mark.present?
          tmp_row.elements[9].attributes['value'].gsub!("0", attestation_mark.mark.to_s)
        end

        tmp_row.elements[10].attributes["formula"].gsub!("7", formula_index.to_s)
        tmp_row.elements[11].attributes["formula"].gsub!("I7", "I#{formula_index.to_s}")
        tmp_row.elements[11].attributes["formula"].gsub!("J7", "J#{formula_index.to_s}")


        #tmp_row.elements[12][1].text = student_achievements(project, participant, :international_reports)
        #tmp_row.elements[13][1].text = student_achievements(project, participant, :diplomas)
        #tmp_row.elements[14][1].text = student_achievements(project, participant, :publications)
        tmp_row.elements[12][1].text = participant.student_achievements.where(stage_id: stage.id, kind: :international_report).map{ |sa| sa.title }.join(", ")
        tmp_row.elements[13][1].text = participant.student_achievements.where(stage_id: stage.id, kind: :diploma).map{ |sa| sa.title }.join(", ")
        tmp_row.elements[14][1].text = participant.student_achievements.where(stage_id: stage.id, kind: :publication).map{ |sa| sa.title }.join(", ")

        table.insert_after("//table:table-row[6+#{participant_index}]", tmp_row)
        participant_index += 1
        i += 1
        formula_index += 1
      end
    end
    document.to_s
  end

  def render_to_file(&block)
    super('chair_attestation', &block)
  end

  def student_achievements(project, participant, kind)
    achievements = project.
               current_attestation_stage.
               try(kind).
               try(:joins, :participants).
               try(:where, 'participants.id = ?', participant)
    if achievements.present?
      return achievements.pluck(:title).join(', ')
    end
  end

  def stage_achievements(project, participant, kind)
    achievements = project.
               current_attestation_stage.
               try(kind)
    if achievements.present?
      return achievements.pluck(:title).join(', ')
    end
  end

  def set_reporting_stage
    return nil unless options[:reporting_stage_id].present?
    @reporting_stage = ReportingStage.find_by(id: options[:reporting_stage_id])
  end

  def detected_participant_name(participant)
    if options[:with_deleted_participants] && participant.deleted?
      ["(ИСКЛ)", participant.name, "(#{participant.deleted_at.to_date})"].join(' ')
    else
      participant.name
    end
  end

  def filtered_deleted_participants(project)
    ids = project.participants.only_deleted.select do |p|
      p.was_deleted_in_chosen_semester(@reporting_stage)
    end.map(&:id)

    ids.any? ? project.participants.with_deleted.where(id: ids) : Participant.none
  end

  def filtered_projects(chair)
    if @reporting_stage.present?
      chair.projects
           .active
           .includes(stages: :reporting_stage)
           .where(reporting_stages: { id: @reporting_stage.id })
    else
      chair.projects.active
    end
  end
end
