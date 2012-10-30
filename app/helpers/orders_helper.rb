# encoding: utf-8

module OrdersHelper
  def order_title(order)
    title = order.title
    if order.approved?
      title += " №#{order.number} от #{order.approved_at}"
    end
    title
  end

  def order_icon(order)
    image_tag "order_#{order.state}.png", :title => "#{order.human_state_name}", :class => "icon", :size => "16x16"
  end

  def order_title_with_projects(order)
    "#{order.title} (проекты #{order.projects_to_s})"
  end

  def review_order_button(order, caption)
    change_order_state_button(review_chair_order_path(order.chair, order), caption)
  end

  def to_review_order_button(order, caption)
    change_order_state_button(to_review_chair_order_path(order.chair, order), caption)
  end

  def cancel_order_button(order, caption)
    change_order_state_button(cancel_chair_order_path(order.chair, order), caption)
  end

  def change_order_state_button(url, caption)
    out = ""
    out << form_tag(url, :method => :put)
    out << label_tag("comment", I18n.t("activity.comment"))
    out << text_area_tag("comment")
    out << submit_tag(caption)
    out << "</form>"
    out.html_safe
  end

  def link_to_file(order, format, caption)
    link_to caption, chair_order_path(order.chair, order, :format => format)
  end

  def order_projects_list(order)
    projects = order.projects
    other_projects = ""
    if projects.length > 3
      n = projects.length - 2
      other_projects = "и еще #{n} #{Order.pluralized_string(n)}"
      projects = projects[0..1]
    end
    out = projects.collect {|project| content_tag :span, link_to(project.cipher, chair_project_path(project.chair, project)), :title => project.title }.join(", ")
    "#{out} #{other_projects}".html_safe
  end
end
