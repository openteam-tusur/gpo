# encoding: utf-8
class ChairAttestation < XlsReport
  attr_accessor :chair

  def initialize chair
    @chair = chair
  end

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("CHAIR_ABBR", @chair.abbr).
              gsub("SEMESTR", self.semestr).
              gsub("EDU_EAYR", self.edu_years).
              gsub("GPO_CHIEF", chair.mentors[0].initials_name).
              gsub("CHAIR_CHIEF", chair.chief).
              gsub("C_YEAR", self.c_year)
    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[7]')
    formula_index = 7
    participant_index = 0
    chair.projects.active.each do |project|
      i = 1
      project.participants.active.each do |participant|
        tmp_row = row.deep_clone

        # deep_clone не всегда deep :(
        # поэтому используем этот хитрый хак, чтобы формулы прокопировались правильно
        tmp_row.elements[10].attributes.inspect
        tmp_row.elements[12].attributes.inspect
        tmp_row.elements[13].attributes.inspect

        if i == 1
          tmp_row.elements[1].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[2].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[3].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[4].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[5].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})

        end
        tmp_row.elements[1][1].text = "#{project.cipher} #{project.title} #{project.people.collect {|person| person}.join(", ")}"


        stage_achievement = project.current_attestation_stage.stage_achievement
        if stage_achievement.present?
          tmp_row.elements[2][1].text = stage_achievement.diploma
          tmp_row.elements[3][1].text = stage_achievement.grant
          tmp_row.elements[4][1].text = stage_achievement.publication
          tmp_row.elements[5][1].text = stage_achievement.exhibition
        else
          (2..6).each do |column_index|
            tmp_row.elements[column_index][1].text = ''
          end
        end

        tmp_row.elements[6][1].text = i
        tmp_row.elements[7][1].text = participant.name
        tmp_row.elements[8][1].text = participant.course
        tmp_row.elements[9][1].text = participant.edu_group
        tmp_row.elements[10][1].text = participant.total_term_mark
        tmp_row.elements[10].attributes['value'].gsub!("0", participant.total_term_mark.round.to_s)


        tmp_row.elements[12].attributes["formula"].gsub!("7", formula_index.to_s)
        tmp_row.elements[13].attributes["formula"].gsub!("K7", "K#{formula_index.to_s}")
        tmp_row.elements[13].attributes["formula"].gsub!("L7", "L#{formula_index.to_s}")

        international_report = project.
                               current_attestation_stage.
                               international_reports.
                               where(participant_id: participant).
                               first

        if international_report.present?
          tmp_row.elements[14][1].text = international_report.description
        end

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
end
