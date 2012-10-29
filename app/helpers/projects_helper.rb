# encoding: utf-8

module ProjectsHelper

  def reopen_project_button(project)
    out = ""
    out << form_tag(reopen_chair_project_path(project.chair, project), :method => :put)
    out << submit_tag(I18n.t("project.reopen"))
    out << "</form>"
    out.html_safe
  end

  def project_managers(project)
    managers = project.users.collect {|user| user.name}.to_sentence
    managers = "не назначен" if managers.blank?
    managers
  end

  def project_section(project, attribute)
    value = project.respond_to?(attribute) ? project.send(attribute) : nil
    out = ""
    unless value.blank?
      out << content_tag(:h3, I18n.t("project.#{attribute}"))
      out << content_tag(:div, value + "", :class => "section")
    end
    out.html_safe
  end

  def project_updated(project)
    "Изменен: #{time_ago(project, :updated_at) || "не известно когда"}".html_safe
  end
end
