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

  def project_section(project, attribute)
    value = project.respond_to?(attribute) ? project.send(attribute) : nil
    out = ""
    unless value.blank?
      out << content_tag(:h3, Project.human_attribute_name(attribute))
      out << content_tag(:div, simple_format(value), :class => "section")
    end
    out.html_safe
  end

  def project_updated(project)
    "Изменен: #{time_ago(project, :updated_at) || "не известно когда"}".html_safe
  end
end
