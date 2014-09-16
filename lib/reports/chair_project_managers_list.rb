# encoding: utf-8
class ChairProjectManagersList < XlsReport
  attr_accessor :chair

  def initialize chair
    @chair = chair
  end

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("CHAIR_ABBR", @chair.abbr)

    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[4]')
    i = 1
    @chair.uniq_project_manager_users.each do |project_manager|
      tmp_row = row.deep_clone
      tmp_row.elements[1][1].text = i
      tmp_row.elements[2][1].text = project_manager.name
      tmp_row.elements[3][1].text = project_manager.managable_projects.collect {|project| project.cipher }.join(', ')
      tmp_row.elements[4][1].text = project_manager.post
      tmp_row.elements[5][1].text = project_manager.float
      tmp_row.elements[6][1].text = project_manager.phone
      tmp_row.elements[7][1].text = project_manager.email
      table.add_element tmp_row
      i += 1
    end
    document.to_s
  end

  def render_to_file(&block)
    super('chair_project_managers_list', &block)
  end


end
