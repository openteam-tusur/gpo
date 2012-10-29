# encoding: utf-8
require "rexml/document"
class UniversityParticipants < XlsReport

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("TODAY", Date.today.to_s)
    # наполняем студентами 3-го курса
    document = REXML::Document.new(xml)
    index = 1
    document.elements.each("//table:table") do |table|
      course = table.attributes["table:name"].split(" ")[0].to_i
      row = table.delete_element("//table:table[#{index}]/table:table-row[3]")
      i = 1
      Participant.active.at_course(course).each do |participant|
        tmp_row = row.deep_clone
        tmp_row.elements[1][1].text = i
        tmp_row.elements[2][1].text = participant.name
        tmp_row.elements[3][1].text = participant.edu_group
        tmp_row.elements[4][1].text = participant.project.cipher
        table.add_element tmp_row
        i += 1
      end
      index += 1
    end
    document.to_s
  end

  def render_to_file(&block)
    super('university_participants', &block)
  end


end
