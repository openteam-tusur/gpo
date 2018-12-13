# encoding: utf-8
require "rexml/document"
class ChairScheduleGroup < XlsReport
  attr_accessor :chair

  def initialize chair
    @chair = chair
  end

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("CHAIR_ABBR", @chair.abbr).gsub("CHAIR_CHIEF", @chair.chief).gsub("YEAR", Date.today.year.to_s).gsub("SEMESTR", self.semestr).gsub("EDU_EAYR", self.edu_years)

    # наполняем проектами
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[7]')
    chair.projects.active.each do |project|
      i = 1
      project.participants.active.each do |participant|
        tmp_row = row.deep_clone
        if i == 1
          tmp_row.elements[1].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[2].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[7].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
          tmp_row.elements[8].add_attributes({"table:number-rows-spanned" => project.participants.active.size.to_s})
        end
        tmp_row.elements[1][1].text = project.cipher
        tmp_row.elements[2][1].text = project.people.collect {|person| person}.join(", ")
        tmp_row.elements[3][1].text = i
        tmp_row.elements[4][1].text = participant.name
        tmp_row.elements[5][1].text = participant.course
        tmp_row.elements[6][1].text = participant.edu_group
        tmp_row.elements[7][1].text = project.auditorium
        tmp_row.elements[8][1].text = project.class_time
        table.add_element tmp_row
        i += 1
      end
    end
    document.to_s
  end

  def render_to_file(&block)
    super('chair_schedule_group', &block)
  end


end
