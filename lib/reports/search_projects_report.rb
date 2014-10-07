# encoding: utf-8
class SearchProjectsReport < XlsReport
  attr_accessor :search_results

  def initialize search_results
    @search_results = search_results
  end

  def process_xml_template(xml)
    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[2]')
    participant_index = 0
    search_results.each do |project|
      i = 1
      project.participants.active.each do |participant|
        tmp_row = row.deep_clone

        if i == 1
          tmp_row.elements[1].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[2].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[3].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[4].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[5].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[11].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[12].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})

        end
        tmp_row.elements[1][1].text = "#{project.cipher} #{project.title}"
        tmp_row.elements[2][1].text = "#{project.people.collect {|person| person}.join(", ")}"
        tmp_row.elements[3][1].text = project.theme.name
        tmp_row.elements[4][1].text = project.category_text
        tmp_row.elements[5][1].text = project.not_interdisciplinary? ? '' : project.interdisciplinary_text
        tmp_row.elements[6][1].text = i
        tmp_row.elements[7][1].text = participant.name
        tmp_row.elements[8][1].text = participant.course
        tmp_row.elements[9][1].text = participant.edu_group
        tmp_row.elements[10][1].text = participant.subfaculty


        tmp_row.elements[11][1].text = project.sbi_placing_resident? ? 'Да' : 'Нет'
        tmp_row.elements[12][1].text = project.active? ? 'Да' : 'Нет'

        table.insert_after("//table:table-row[1+#{participant_index}]", tmp_row)
        participant_index += 1
        i += 1
      end
    end
    document.to_s
  end

  def render_to_file(&block)
    super('search_projects_report', &block)
  end
end

