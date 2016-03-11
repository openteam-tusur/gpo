# encoding: utf-8
require "rexml/document"
class UniversityProjects < XlsReport

  def process_xml_template(xml)
    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[2]')
    Project.active.includes(:chair).order('chairs.abbr, cipher').each do |project|
      tmp_row = row.deep_clone
      tmp_row.elements[1][1].text = project.cipher
      tmp_row.elements[2][1].text = project.title
      tmp_row.elements[3][1].text = project.chair.abbr
      tmp_row.elements[4][1].text = project.theme.try(:name)
      tmp_row.elements[5][1].text = project.stakeholders
      tmp_row.elements[6][1].text = project.people.collect {|person| person}.join(", ")
      tmp_row.elements[7][1].text = project.participants.active.count
      table.add_element tmp_row
    end
    document.to_s
  end

  def render_to_file(&block)
    super('university_projects', &block)
  end


end
