Given /^в расписании существует день ГПО "([^\"]*)"(.*)?$/ do |date, kt|
  Authorization::Maintenance::without_access_control do
    kt = kt.blank? ? 0 : 1
    post gpodays_url, :gpoday => {:date => date, :kt => kt}
  end
end

Given /^в расписании существует день ГПО (\d) д\w+ назад$/ do |d|
  Authorization::Maintenance::without_access_control do
    post gpodays_path, :gpoday => {:date => (Date.today - d.to_i).to_s}
  end
end

Then /^мне (\w+) создание дня ГПО$/ do |permission|
  visit gpodays_url
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Добавить"}
  visit new_gpoday_path
  Then "мне должно быть #{permission}"
  post gpodays_path, :gpoday => {:date => "24.09.2009"}
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) просмотр расписания ГПО$/ do |permission|
  # TODO: сначала перейти на settings, затем вижу/не вижу gpodays_url, а уже потом
  visit gpodays_url
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) редактирование дня ГПО$/ do |permission|
  Given %{в расписании существует день ГПО "24.09.2009"}
  visit gpodays_url
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Редактировать"}
  day = Gpoday.first
  visit edit_gpoday_path(day)
  Then "мне должно быть #{permission}"
  put gpoday_path(day), :gpoday => {:date => "24.09.2009"}
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) удаление дня ГПО$/ do |permission|
  Given %{в расписании существует день ГПО "24.09.2009"}
  visit gpodays_url
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Удалить"}
  day = Gpoday.first
  delete gpoday_path(day)
  Then "мне должно быть #{permission}"
end

