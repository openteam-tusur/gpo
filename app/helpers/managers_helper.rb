# encoding: utf-8

module ManagersHelper
  def manager_projects(user)
    safe_join user.managable_projects.collect {|project| content_tag :span, link_to(project.cipher, chair_project_path(project.chair, project)) }, ", "
  end
end
