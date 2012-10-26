# encoding: utf-8

module ThemesHelper

  def project_theme(project, show = false)
    out = ""
    out << content_tag(:h3, "Направление") if show
    unless project.theme
      out << content_tag(:div, "Не указано направление", :class => "theme section error")
    else
      out << content_tag(:div, project.theme.name, :class => "theme section")
    end
    out
  end

end
