# encoding: utf-8
class ChairScheduleProjectManagers < XlsReport
  attr_accessor :chair

  def initialize chair
    @chair = chair
  end

  def process_xml_template(xml)
    # меняем статический контент в шаблоне
    xml = xml.gsub("CHAIR_ABBR", @chair.abbr).gsub("CHAIR_CHIEF", @chair.chief).gsub("C_YEAR", Date.today.year.to_s).gsub("SEMESTR", self.semestr).gsub("EDU_YEARS", self.edu_years)

    # наполняем руководителями
    document = REXML::Document.new(xml)
    table = document.elements["//table:table"]
    row = table.delete_element('//table:table-row[7]')
    @chair.uniq_project_manager_users.each do |person|
      i = 1
      person.project_managers.active.each do |pm|
        tmp_row = row.deep_clone
        if i == 1
          tmp_row.elements[1].add_attributes({"table:number-rows-spanned" => person.managable_projects.size.to_s})
          tmp_row.elements[2].add_attributes({"table:number-rows-spanned" => person.managable_projects.size.to_s})
        end
        tmp_row.elements[1][1].text = person
        tmp_row.elements[2][1].text = person.post
        tmp_row.elements[3][1].text = pm.project.cipher
        tmp_row.elements[4][1].text = pm.auditorium
        tmp_row.elements[5][1].text = pm.consultation_time
        tmp_row.elements[6][1].text = Participant.for_project_manager(pm.id).pluck(:edu_group).uniq.join(', ')
        table.add_element tmp_row
        i += 1
      end
    end
    document.to_s
  end

  def render_to_file(&block)
    super('chair_schedule_project_managers', &block)
  end


end
