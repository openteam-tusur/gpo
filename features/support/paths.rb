module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    pages = {
      "главной странице" => root_path,
      "моей странице" => dashboard_path,

      "странице авторизации" => login_path,
      "странице напоминания пароля" => forgot_password_path,

      "странице списка кафедр" => chairs_path,
      "странице добавления кафедры" => new_chair_path,

      "странице списка пользователей" => users_path,
      "странице добавления пользователя" => new_user_path,

      "странице списка правил" => rules_path,
      "странице добавления правила" => new_rule_path,

      "странице списка студентов" => students_path,
      "странице списка проблемных студентов" => problematic_students_path,

      "странице создания дня ГПО" => new_gpoday_path,
      "странице расписания ГПО" => gpodays_path

    }
    if pages.has_key?(page_name)
      pages[page_name]
    else
      if (page_name.match(/странице ".*"/))
        page_name.gsub(/странице "(.*)"/, '\1')
      else
        raise "Не могу найти маппинг для страницы \"#{page_name}\".\n" +
          "Добавь маппинг в #{__FILE__}!"
      end
    end
  end
end

World(NavigationHelpers)

