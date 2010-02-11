class ChairProjectsStat < XlsReport
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
    row = table.delete_element('//table:table-row[3]')
    index = 1
    chair.projects.active.each do |project|
      unless project.participants.active.empty?
        tmp_row = row.deep_clone
        tmp_row.elements[1][1].text = "#{index}."
        tmp_row.elements[2][1].text = project.cipher
        tmp_row.elements[3][1].text = project.title
        tmp_row.elements[4][1].text = project.users.collect {|user| user.name}.join(", ")
        tmp_row.elements[5][1].text = project.participants.active.at_course("3").size
        tmp_row.elements[5].attributes["office:value"] = project.participants.active.at_course("3").size.to_s

        tmp_row.elements[6][1].text = project.participants.active.at_course("4").size
        tmp_row.elements[6].attributes["office:value"] = project.participants.active.at_course("4").size.to_s

        tmp_row.elements[7][1].text = project.participants.active.at_course("5").size
        tmp_row.elements[7].attributes["office:value"] = project.participants.active.at_course("5").size.to_s

        tmp_row.elements[8][1].text = project.participants.active.size
        tmp_row.elements[8].attributes["office:value"] = project.participants.active.size.to_s

        table.add_element tmp_row
        index += 1
      end
    end
    document.to_s
  end

  def render_to_file(&block)
    super('chair_projects_stat', &block)
  end


end
