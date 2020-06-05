# encoding: utf-8

module ProjectsHelper

  def reopen_project_button(project)
    out = ""
    out << form_tag(reopen_manage_chair_project_path(project.chair, project), :method => :put, :class => "simple_form")
    out << submit_tag(Project.human_state_event_name(:reopen), :class => "button")
    out << "</form>"
    out.html_safe
  end

  def project_project_managers(project)
    project_managers = project.people.to_sentence
    project_managers = "не назначен" if project_managers.blank?
    project_managers
  end

  def closed_project_project_managers(project)
    project_managers = project.project_managers.with_deleted.to_sentence
    project_managers = "не назначен" if project_managers.blank?
    project_managers
  end

  def project_participants(project)
    if project.participants.any?
      project_participants = project.participants.sort_by(&:last_name).map {|p| "#{p.name} (гр. #{p.edu_group}, каф. #{p.subfaculty})"}.join(', ')
    else
      project_participants = 'не назначены'
    end
  end

  def project_section(project, attribute, rendered = false)
    value = project.respond_to?(attribute) ?
      (project.respond_to?("#{attribute}_text") ? project.send("#{attribute}_text") : project.send(attribute)) : nil
    out = ""
    if !value.blank? || rendered
      out << content_tag(:h3, Project.human_attribute_name(attribute))
      if value.blank?
        out << content_tag(:div, "Не заполнено", :class => "section blank")
      else
        out << content_tag(:div, simple_format(value), :class => "section")
      end
    end
    out.html_safe
  end

  def project_stages_status(project)
    return nil if project.unfilled_stages.empty?
    "#{icon(:warning)} Необходимо заполнить #{t 'projects.unfilled_stages', count: project.unfilled_stages.count}".html_safe
  end

  def project_executives_status(project)
    return nil if project.participants.as_executive.present?
    "#{icon(:warning)} Необходимо выбрать ответственного исполнителя".html_safe
  end

  def project_updated(project)
    "Изменен: #{time_ago(project, :updated_at) || "не известно когда"}".html_safe
  end
end
