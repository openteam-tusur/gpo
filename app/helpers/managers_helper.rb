# encoding: utf-8

module ManagersHelper

  def manager_cancel_state_button(button_name, manager)
    manager_change_state_form(cancel_manage_chair_project_manager_path(manager.project.chair, manager.project, manager), button_name)
  end

  def manager_approve_state_button(button_name, manager)
    manager_change_state_form(approve_manage_chair_project_manager_path(manager.project.chair, manager.project, manager), button_name)
  end

  def manager_change_state_form(url, button_name)
    out = ""
    out << form_tag(url, :method => :put, :class => "simple_form")
    out << submit_tag(button_name, :class => "button")
    out << "</form>"
    out.html_safe
  end

  def manager_projects(user)
    user.managable_projects.collect {|project| content_tag :span, link_to(project.cipher, chair_project_path(project.chair, project)) }.join(", ")
  end
end
