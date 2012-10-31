# encoding: utf-8

module UsersHelper

  def if_authorized?(action, resource, &block)
    if authorized?(action, resource)
      yield action, resource
    end
  end

  def link_to_user(user, options={})
    raise "Invalid user" unless user
    options.reverse_merge! :content_method => :login, :title_method => :login, :class => :nickname
    content_text      = options.delete(:content_text)
    content_text    ||= user.send(options.delete(:content_method))
    options[:title] ||= user.send(options.delete(:title_method))
    link_to content_text, user_path(user), options
  end

  def link_to_login_with_IP content_text=nil, options={}
    ip_addr           = request.remote_ip
    content_text    ||= ip_addr
    options.reverse_merge! :title => ip_addr
    if tag = options.delete(:tag)
      content_tag tag, content_text, options
    else
      link_to content_text, login_path, options
    end
  end

  def link_to_current_user(options={})
    if current_user
      link_to_user current_user, options
    else
      content_text = options.delete(:content_text) || "not signed in"
      [:content_method, :title_method].each{|opt| options.delete(opt)}
      link_to_login_with_IP content_text, options
    end
  end

  def new_user_title(chair)
    if chair.nil?
      "Добавление нового пользователя"
    else
      "Добавление нового пользователя на кафедру #{chair.abbr}"
    end
  end

  def users_title(chair)
    if chair.nil?
      "Пользователи"
    else
      "Пользователи кафедры #{chair.abbr}"
    end
  end

  def link_to_edit_user(user, chair)
    link_to(I18n.t("edit"), chair.nil? ? edit_manage_user_path(user) : edit_manage_chair_user_path(chair, user) )
  end

  def link_to_delete_user(user, chair)
    if chair.nil?
      link_to_delete(manage_user_path(user))
    else
      link_to_delete(manage_chair_user_path(chair, user))
    end
  end

  def user_post(user)
    post = []
    post << "Кафедра #{user.chair.abbr}" if user.chair
    post << user.post unless user.post.blank?
    post.join(", ")
  end

end
