def find_or_create_theme(theme_name = "Программирование")
  return nil if theme_name.nil? || theme_name.blank?
  Theme.find_by_name(theme_name) || Factory(:theme, {:name => theme_name})
end

Given /^в базе существ\w+ направлен\w+ "(.*?)"$/ do |names|
  names.split(", ").each do |name|
    Factory(:theme, {:name => name})
  end
end

Then /^мне (\w+) просмотр списка направлений$/ do |permission|
  can_visit themes_url, permission, "могу просмотреть список направлений"
end

Then /^мне (\w+) просмотр проектов по направлениям$/ do |permission|
  theme = find_or_create_theme()
  visit projects_themes_url(:themes => [theme.id])
  check_errors_after_visit(permission, "могу просмотреть проекты по направлениям")
end

Then /^мне (\w+) добавление направления$/ do |permission|
  visit new_theme_url
  check_errors_after_visit(permission, "могу просмотреть форму создания направления")
  assert_create_allowed(Theme, themes_url,
    {:theme => {:name => "программирование"}}, permission, "могу создать направление")
end

Then /^мне (\w+) редактирование направления$/ do |permission|
  theme = find_or_create_theme()
  can_visit edit_theme_url(theme), permission, "могу посмотреть форму редактирования направления"
  visit theme_url(theme), :put, {:theme => {:name => "новое название"}}
  assert_update_allowed(theme.name, Theme.find(theme.id).name, permission, "могу обновить направление")  
end

Then /^мне (\w+) удаление направления$/ do |permission|
  theme = find_or_create_theme
  assert_delete_allowed(Theme, theme_url(theme), permission, "могу удалить направление")
end
