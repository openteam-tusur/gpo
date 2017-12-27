# encoding: utf-8

module ApplicationHelper
  def permitted_to?(*args)
    can? *args
  end

  def nav_link(link, current_controller, options = {})
    current_action = options[:action]
    id = current_controller
    id << %(_#{current_action}) if current_action
    controller_match = (controller.controller_name.include?(current_controller))
    action_match = current_action ? (current_action == controller.action_name) : true
    selected = controller_match && action_match
    unless options[:selected].nil?
      selected = options[:selected]
    end
    css_class = selected ? 'current' : ''
    img = image_tag %(nav_#{id}.png), class: 'icon', size: '16x16'
    content_tag :li, img + link, class: css_class, id: %(link_to_#{id})
  end

  def include_container
    case controller.controller_name
    when 'visitations'
      'container_one_column'
    when 'issues'
      'container_one_column'
    when 'search_projects'
      'container_one_column'
    when 'statistics'
      'container_one_column'
    when 'certificates'
      'container_one_column'
    when 'stages'
      if controller.action_name == 'edit'
        'container_one_column'
      else
        'container_two_column'
      end
    else
      'container_two_column'
    end
  end

  def submenu
    case controller.controller_name
    when 'users'
      'user_navigation'
    when 'reports'
      'report_navigation'
    when 'search_projects'
      'report_navigation'
    when 'statistics'
      'report_navigation'
    when 'themes'
      case controller.action_name
      when 'statistics', 'projects'
        'report_navigation'
      else
        'settings_navigation'
      end
    when 'gpodays', 'reporting_stages', 'permissions'
      'settings_navigation'
    when 'visitations'
      'report_navigation'
    else
      'navigation'
    end
  end

  def inline_nav_link(link, selected)
    css_class = selected ? 'current' : ''
    content_tag :li, link, :class => css_class
  end

  def action_link(link, action_class = nil, description_text = nil)
    description = ""
    description = content_tag :span, description_text unless description_text.blank?
    content_for :action_nav, content_tag(:li, link + description, class: ['action', action_class])
  end

  def hint(content)
    content_tag :div, content, class: 'hint'
  end

  def link_to_delete(url, link_title = nil)
    link_title ||= I18n.t('delete')
    link_to link_title, url, method: :delete, data: { confirm: I18n.t('are_you_sure') }
  end

  def render_list(item_partial, items, options = {})
    if items.any?
      object = options.delete(:object) || item_partial.split('/').last.to_sym
      content = items.collect {|item|
        item_class = [cycle('odd', 'even')]
        item_class << options[:item_class] if options[:item_class]
        content_tag(:li,
          render(partial: item_partial,
                 locals: { object: item, order: item, chair_project_manager: item,
                           task: item, activity: item, report: item, theme: item,
                           gpoday: item, stage: item, permission: item, project: item,
                           project_manager: item }),
          class: item_class.join(' '))
      }.join

      css_class = ['listing']
      css_class << options[:class] if options[:class]

      content_tag :ul, content.html_safe, id: options[:id], class: css_class.join(' ')
    else
      content_tag :div, (options[:if_empty] || 'В списке нет элементов') , class: 'empty-list'
    end
  end

  def icon(style, options = {})
    options[:class] ||= "icon"
    options[:alt] ||= options[:title] unless options[:title].nil?
    options[:size] ||= "16x16"
    image_tag("icon_#{style}.png", options)
  end

  def iconed_title(text, icon_style)
    icon(icon_style) + text
  end

  def render_table_stats(stats)
    rows = stats.collect { |stat|
      content_tag :tr, content_tag(:td, stat.title) + content_tag(:td, stat.value, :class => "value"), :class => cycle("odd", "even") + stat.key.to_s
    }.join
    content_tag :table, rows.html_safe
  end

  def render_inline_stats(stats, options = {})
    term ||= content_tag :dt, options[:term] unless options[:term].nil?

    stats.collect { |stat|
      term += content_tag :dd, stat.value, :title => stat.title, :class => stat.key
    }

    content_tag :dl, term.to_s
  end

  def task_path(task)
    case task
     when OrderTaskManager
       manage_chair_order_path(task.order.chair, task.order)
     when ProblematicParticipantsTaskManager
       manage_chair_project_participants_path(task.project.chair, task.project)
     when ProjectVisitationsTaskManager
       manage_chair_project_visitations_path(task.project.chair, task.project)
     else
       raise "Неизвестная задача"
    end
  end

  def title(text, id)
    content_for :title, text
    content_for :page_title, icon(id) + text
  end

  def date(datetime)
    I18n.l(datetime.to_date) rescue nil
  end

  def date_with_time(datetime)
    I18n.l(datetime, :format => :short)  rescue nil
  end

  def time_ago(object, method = :created_at)
    unless object.nil? || object.send(method).nil?
      exact_time = object.send method
      content_tag :span, "#{distance_of_time_in_words(exact_time, Time.now)} назад", title: I18n.l(exact_time, :format => :long)
    else
      nil
    end
  end

  def help_term(term)
    image_tag "help/#{term}.png"
  end

end
