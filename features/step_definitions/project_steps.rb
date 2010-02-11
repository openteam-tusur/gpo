def find_or_create_project(cipher = nil, chair = nil)
  cipher ||= "АОИ-0701"
  chair ||= find_or_create_chair(cipher.split("-")[0])
  Project.find_by_cipher(cipher) || Factory(:project, :cipher => cipher, :chair => chair)
end

def find_or_create_project_by_match(match = "АОИ-0701")
  chair = find_or_create_chair_by_match(match)
  if /(\w+)-(\w+)/ =~ match
    cipher = match.strip
  else
    cipher = "#{chair.abbr}-0701"
  end
  Project.find_by_cipher(cipher) || Factory(:project, :cipher => cipher, :chair => chair)
end

def valid_project_attributes(chair, title = nil)
  {:project => {:title => title || "название проекта", :chair_id => chair.id}}
end

def assert_update_allowed(old_object, new_object, permission, message)
  if permission =~ /разреш/
    assert_not_equal old_object, new_object, "не #{message}"
  else
    assert_equal old_object, new_object, message
  end
end

def get_project_state(state_description)
  case state_description
  when "черновик" then state = 'draft'
  when "активный" then state = 'active'
  when "закрыт" then state = 'closed'
  else raise "Неправильное состояние проекта"
  end
end

def get_project_editable_state(state_description)
  case state_description
  when "правки запрещены" then state = 'blocked'
  when "правки разрешены" then state = 'editable'
  else raise "Неправильное состояние редактирования проекта"
  end
end

Given /^в базе существуют следующие проекты$/ do |table|
  Project.transaction do
    Project.destroy_all
    table.hashes.each do |project|
      project = project.dup
      chair_abbr = project.delete("chair")
      theme_name = project.delete("theme")
      project[:chair] = find_or_create_chair(chair_abbr)
      project[:theme] = find_or_create_theme(theme_name)

      state = project.delete("state")
      editable_state = project.delete("editable_state")

      p = Factory(:project, project)
      p.state = state unless state.blank?
      p.editable_state = editable_state unless editable_state.blank?
      p.save(false)
    end
  end
end

Given /^в базе существуют (\d+) (\w+) проектов на кафедре (\w+)$/ do |count, state, chair_abbr|
  chair = find_or_create_chair(chair_abbr)
  count.to_i.times do
    p = Factory(:project, :chair => chair)
    case state
    when /актив/ then p.state = 'active'
    when /архив/ then p.state = 'closed'
    when /чернов/ then p.state = 'draft'
    else raise "Неправильное состояние проекта"
    end
    p.save(false)
  end
end

Given /^я на странице списка проектов кафедры "(.*)"/ do |abbr|
  chair = find_or_create_chair(abbr)
  visit chair_projects_url(chair)
end

Given /^я на странице добавления проекта кафедры (\w+)$/ do | abbr |
  chair = find_or_create_chair(abbr)
  visit new_chair_project_url(chair)
end

Given /^в базе нет проектов$/ do
  Project.destroy_all
end

Given /^я на странице проекта (.*)$/ do | match |
  project = find_or_create_project_by_match(match)
  visit chair_project_url(project.chair, project)
end

Then /^в базе долж\w+ быть (\d+) проект\w* (.*)$/ do |num, match|
  chair = find_or_create_chair_by_match(match)
  assert_equal num.to_i, chair.projects.count
end

Then /мне (запрещ\w+|разреш\w+) просмотр списка проектов\s*(.*)$/ do |permission, match|
  chair = find_or_create_chair_by_match(match)
  can_visit chair_projects_url(chair), permission, "вижу список проектов #{chair.abbr}"
end

Then /мне (запрещ\w+|разреш\w+) просмотр проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit chair_project_url(project.chair, project), permission, "вижу проект #{project.cipher} кафедры #{project.chair.abbr}"
end

Then /мне (запрещ\w+|разреш\w+) просмотр формы создания проекта\s*(.*)$/ do |permission, match|
  chair = find_or_create_chair_by_match(match)
  visit chair_projects_path(chair)
  if allow?(permission)
    Then %{я вижу "Новый проект"}
  else
    Then %{я не вижу "Новый проект"}
  end
  can_visit new_chair_project_url(chair), permission, "вижу форму создания проекта кафедры #{chair.abbr}"
end

Then /мне (запрещ\w+|разреш\w+) создание проекта\s*(.*)$/ do |permission, match|
  chair = find_or_create_chair_by_match(match)
  assert_create_allowed(chair.projects, chair_projects_url(chair),
    valid_project_attributes(chair), permission, "могу создать проект")
end

Then /мне (запрещ\w+|разреш\w+) просмотр формы редактирования проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit edit_chair_project_url(project.chair, project), permission, "вижу форму редактирования проекта"
end

Then /мне (запрещ\w+|разреш\w+) обновление проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  visit chair_project_url(project.chair, project), :put,
    valid_project_attributes(project.chair, "новое название проекта")
  assert_update_allowed(project.title, Project.find(project.id).title, permission, "могу обновить проект")
end

Then /мне (запрещ\w+|разреш\w+) обновление названия проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  visit chair_project_url(project.chair, project), :put,
    valid_project_attributes(project.chair, "новое название проекта")
  assert_update_allowed(project.title, Project.find(project.id).title, permission, "могу обновить проект")
end

Then /мне (запрещ\w+|разреш\w+) удаление проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  assert_delete_allowed(project.chair.projects, chair_project_url(project.chair, project),
    permission, "могу удалить проект")
end

Then /проект(?:\w+)? (.*) долж\w+ быть с состояниями "(.*)" и "(.*)"$/ do |matches, state_description, editable_state_description|
  matches.split(",").each do |match|
    match.strip!
    unless match.blank?
      project = find_or_create_project_by_match(match)
      assert_equal get_project_state(state_description), project.state, "Неверное состояние проекта"
      assert_equal get_project_editable_state(editable_state_description), project.editable_state, "Неверное состояние редактируемости проекта"
    end
  end
end

Then /мне (запрещ\w+|разреш\w+) закрыть проект\s*(\w+-\d+)?/ do |permission, project_cipher|
  project = find_or_create_project_by_match(project_cipher)
  can_visit to_close_chair_project_url(project.chair, project), permission, "могу закрыть проект #{project.cipher}"
  visit close_chair_project_url(project.chair, project), :put
  check_errors_after_visit(permission, "могу выполнить действие закрытия проекта #{project.cipher}")
end

Then /мне (запрещ\w+|разреш\w+) возобновлять проект\s*(\w+-\d+)?/ do |permission, project_cipher|
  project = find_or_create_project_by_match(project_cipher)
  visit reopen_chair_project_url(project.chair, project), :put
  check_errors_after_visit(permission, "могу выполнить действие возобновление проекта #{project.cipher}")
end
Then /в базе не должно быть связок проекта (\w+-\d+) с приказом/ do |project_cipher|
  project = find_or_create_project_by_match(project_cipher)
  assert project.order_projects.empty?, "есть связки с приказом у проекта #{project.cipher}"
end

Then /мне (запрещ\w+|разреш\w+) просмотр архива приказов проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit chair_project_orders_url(project.chair, project), permission, "вижу архив приказов проекта"
end

Then /^проект (\w+-\d+) изменился только что$/ do |project_cipher|
  project = find_or_create_project_by_match(project_cipher)
  assert (Time.now.to_i - project.updated_at.to_i) < 2, "дата изменения проекта не изменилась"
end

Given /^у проекта (\w+-\d+) дата обновления "(.*)"$/ do |project_cipher, updated_at|
  project = find_or_create_project_by_match(project_cipher)
  Project.record_timestamps = false
  project.updated_at = updated_at
  project.save
end

