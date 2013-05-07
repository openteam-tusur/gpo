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
    project_managers = project.users.collect {|user| user.name}.to_sentence
    project_managers = "не назначен" if project_managers.blank?
    project_managers
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

  def project_updated(project)
    "Изменен: #{time_ago(project, :updated_at) || "не известно когда"}".html_safe
  end
end
