# encoding: utf-8
class ParticipantIssues < XlsReport
  attr_accessor :participant

  def initialize participant
    @participant = participant
  end

  def process_xml_template(xml)
    project = participant.project
    xml = xml.gsub("SEMESTR", self.semestr).gsub("EDU_YEAR", self.edu_years).gsub("PROJECT_CIPHER", project.cipher).gsub("PROJECT_TITLE", project.title).gsub("PARTICIPANT_NAME", participant.name).gsub("PARTICIPANT_GROUP", participant.edu_group)

    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[6]')
    summ_plan_grade = 0
    summ_grade = 0
    participant.issues.each_with_index do |issue, index|
      tmp_row = row.deep_clone

      tmp_row.elements[4].attributes.inspect
      tmp_row.elements[5].attributes.inspect
      tmp_row.elements[6].attributes.inspect
      tmp_row.elements[7].attributes.inspect

      tmp_row.elements[1][1].text = index+1
      tmp_row.elements[2][1].text = issue.name
      tmp_row.elements[3][1].text = issue.description

      tmp_row.elements[4].attributes['date-value'].gsub!("2010-01-01", issue.planned_closing_at.to_s(:format => :long))
      tmp_row.elements[4][1].text = "'" + issue.planned_closing_at.to_s

      if issue.closed_at
        tmp_row.elements[5].attributes['date-value'].gsub!("2010-01-02", issue.closed_at.to_s(:format => :long))
        tmp_row.elements[5][1].text = "'" + issue.closed_at.to_s
        tmp_row.elements[7].attributes['value'].gsub!("0", issue.grade.to_s)
        tmp_row.elements[7][1].text = issue.grade
        summ_grade += issue.grade
      else
        tmp_row.elements[5] = tmp_row.elements[2].deep_clone
        tmp_row.elements[5][1].text = ""
        tmp_row.elements[7] = tmp_row.elements[2].deep_clone
        tmp_row.elements[7][1].text = ""
      end

      summ_plan_grade += issue.planned_grade
      tmp_row.elements[6].attributes['value'].gsub!("1", issue.planned_grade.to_s)
      tmp_row.elements[6][1].text = issue.planned_grade

      tmp_row.elements[8][1].text = issue.results ? issue.results : ""

      table.insert_after("//table:table-row[5+#{index}]", tmp_row)
    end
    summ_row = table.delete_element("//table:table-row[5+#{participant.issues.size}+1]")

    summ_row.elements[4].attributes['formula'].gsub!(".F6:.F6", ".F6:.F#{5+participant.issues.size}")
    summ_row.elements[4].attributes['value'].gsub!("1", summ_plan_grade.to_s)
    summ_row.elements[4][1].text = summ_plan_grade

    summ_row.elements[5].attributes['formula'].gsub!(".G6:.G6", ".G6:.G#{5+participant.issues.size}")
    summ_row.elements[5].attributes['value'].gsub!("0", summ_grade.to_s)
    summ_row.elements[5][1].text = summ_grade

    table.insert_after("//table:table-row[5+#{participant.issues.size}]", summ_row)
    document.to_s
  end

  def render_to_file(&block)
    super('participant_issues', &block)
  end

end
