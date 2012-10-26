# encoding: utf-8

module ManagersHelper

  def manager_cancel_state_button(button_name, manager)
    manager_change_state_form(cancel_chair_project_manager_url(manager.project.chair, manager.project, manager), button_name)
  end

  def manager_approve_state_button(button_name, manager)
    manager_change_state_form(approve_chair_project_manager_url(manager.project.chair, manager.project, manager), button_name)
  end

  def manager_change_state_form(url, button_name)
    out = ""
    out << form_tag(url, :method => :put)
    out << submit_tag(button_name)
    out << "</form>"
    out
  end

  def manager_projects(user)
    user.managable_projects.collect {|project| content_tag :span, link_to(project.cipher, chair_project_url(project.chair, project)) }.join(", ")
  end
end
