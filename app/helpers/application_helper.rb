module ApplicationHelper

  def nav_link(link, current_controller, options = {})
    current_action = options[:action]
    id = "#{current_controller}"
    id << "_#{current_action}" if current_action
    controller_match = (current_controller == controller.controller_name)
    action_match = current_action ? (current_action == controller.action_name) : true
    selected = controller_match && action_match
    unless options[:selected].nil?
      selected = options[:selected]
    end
    css_class = selected ? "current" : ""
    img = image_tag "nav_#{id}.png", :class => 'icon'
    content_tag :li, img + link, :class => css_class, :id => "link_to_#{id}"
  end

  def include_container
    case controller.controller_name
    when "visitations"
      "container_one_column"
    else
      "container_two_column"
    end
  end

  def submenu
    case controller.controller_name
    when "users", "rules"
      "user_navigation"
    when "reports"
      "report_navigation"
    when "themes"
      case controller.action_name
      when "statistics", "projects"
        "report_navigation"
      else
        "settings_navigation"
      end
    when "gpodays"
      "settings_navigation"
    when "visitations"
      "report_navigation"
    else
      "navigation"
    end
  end

  def inline_nav_link(link, selected)
    css_class = selected ? "current" : ""
    content_tag :li, link, :class => css_class
  end

  def action_link(link, action_class = nil, description_text = nil)
    description = ""
    description = content_tag :span, description_text unless description_text.blank?
    content_for :action_nav, content_tag(:li, link + description, :class => "action #{action_class}")
  end

  def hint(content)
    content_tag :div, content, :class => 'hint'
  end

  def link_to_delete(url, link_title = nil)
    link_title ||= l(:delete)
    link_to link_title, url, :method => :delete, :confirm => l(:are_you_sure)
  end

  def render_list(item_partial, items, options = {})
    options[:if_empty] ||= "В списке нет элементов"
    object = options.delete(:object) || :object
    unless items.blank?
      content = items.collect {|item|
        item_class = [cycle('odd ', 'even ')]
        item_class << options[:item_class] if options[:item_class]
        content_tag(:li, render(:partial => item_partial, :locals => {object => item}), :class => item_class.join(' '))
      }.join

      css_class = ['listing']
      css_class << options[:class] if options[:class]

      content_tag :ul, content, :id => options[:id], :class => css_class.join(' ')
    else
      content_tag :div, options[:if_empty], :class => 'empty-list'
    end
  end

  def icon(style, options = {})
    options[:class] ||= "icon"
    options[:alt] ||= options[:title] unless options[:title].nil?
    image_tag("icon_#{style}.png", options)
  end

  def iconed_title(text, icon_style)
    icon(icon_style) + text
  end

  def render_table_stats(stats)
    rows = stats.collect { |stat|
      content_tag :tr, content_tag(:td, stat.title) + content_tag(:td, stat.value, :class=>'value'), :class => cycle('odd ', 'even ') + stat.key.to_s
    }.join
    content_tag :table, rows
  end

  def render_inline_stats(stats, options = {})
    term ||= content_tag :dt, options[:term] unless options[:term].nil?

    items = stats.collect { |stat|
      content_tag :dd, stat.value, :title => stat.title, :class => stat.key
    }.join

    content_tag :dl, term.to_s + items
  end

  def task_url(task)
    case task
     when OrderTask
       chair_order_url(task.order.chair, task.order)
     when ProblematicParticipantsTask
       chair_project_participants_url(task.project.chair, task.project)
     when ProjectVisitationsTask
       chair_project_visitations_path(task.project.chair, task.project)
     else
       raise "Неизвестная задача"
    end
  end

  def title(text, id)
    content_for :title, text
    content_for :page_title, icon(id) + text
  end

  def date(datetime)
    localize(datetime.to_date) rescue nil
  end

  def date_with_time(datetime)
    localize(datetime, :format => :short)  rescue nil
  end

  def time_ago(object, method = :created_at)
    unless object.nil? || object.send(method).nil?
      exact_time = object.send method
      "<span title='#{exact_time.to_s(:long)}'>#{distance_of_time_in_words(exact_time, Time.now)} назад</span>"
    else
      nil
    end
  end

  def help_term(term)
    image_tag "/images/help/#{term}.png"
  end

end

