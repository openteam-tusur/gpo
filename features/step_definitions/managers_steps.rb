def valid_manager_attributes(project, user)
  {:manager => {:project_id => project.id, :user_id => user.id}}
end

def create_project_manager(match, state="awaiting_approval")
  project = find_or_create_project_by_match(match)
  
  user = Factory(:user)
  
  manager = Factory(:manager, :project => project, :user => user)
  
  manager.state = state
  manager.save(false)

  manager
end


def get_manager_state(state_description)
  case state_description
  when "Утверждён" then state = 'approved'
  else raise "Неправильное состояние проекта"
  end
end

Given /^в базе существуют следующие руководители$/ do |table|
  Manager.destroy_all
  table.hashes.each do |manager|
    manager = manager.dup
    user = User.find_by_login manager.delete("user")
    manager[:user] = user
    
    project = find_or_create_project_by_match(manager.delete("project"))
    manager[:project] = project
    
    state = manager.delete("state")
    m = Factory(:manager, manager)
    unless state.blank?
      m.state = state
      m.save(false)
    end
  end
end

Given /^я на странице списка руководителей проекта (.*)$/ do |match|
  project = find_or_create_project_by_match(match)
  visit chair_project_managers_url(project.chair, project)
end

Then /^мне (запрещ\w+|разреш\w+) просмотр списка руководителей проектов\s*(.*)$/ do |permission, match|
  chair = find_or_create_chair_by_match(match)
  can_visit managers_chair_url(chair), permission, "могу просмотреть список руководителей проектов кафедры #{chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр списка руководителей проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit chair_project_managers_url(project.chair, project), permission, "могу просмотреть список руководителей проекта #{project.cipher}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы назначения руководителя проекта\s*(.*)$/ do |permission,  match|
  project = find_or_create_project_by_match(match)
  can_visit new_chair_project_manager_url(project.chair, project), permission, "могу просмотреть форму создания руководителя проекта кафедры #{project.chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) назначение руководителя проекта\s*(.*)$/ do |permission, match|
  
  manager = create_project_manager(match)
  old_state = manager.state

  assert_create_allowed manager.project.managers,
    chair_project_managers_url(manager.project.chair, manager.project),
    valid_manager_attributes(manager.project, Factory(:user)),
    permission, 
    "могу создать руководителя проекта #{manager.project.cipher}"

  manager = Manager.find_by_id(manager.id)
  
  assert (allow?(permission) && manager.awaiting_approval?) ||
    (deny?(permission) && manager.state == old_state)
  
end
  
Then /^мне (запрещ\w+|разреш\w+) удаление руководителя проекта\s*(\w+-\d+)?(?: в состоянии "(.*)")?$/ do |permission, match, state|
  state  ||= "approved"
  
  manager = create_project_manager(match, state);
  old_count = manager.project.managers.count
  old_state = manager.state
  
  visit chair_project_manager_url(manager.project.chair, manager.project, manager), :delete
  
  assert_equal old_count, manager.project.managers.count
  
  manager = Manager.find_by_id(manager.id)
  
  assert (allow?(permission) && manager.awaiting_removal?) ||
    (deny?(permission) && manager.state == old_state), "не могу удалить руководителя проекта"
end

Then /руководитель (.*) проекта (.*) должен быть в состоянии "(.*)"$/ do |user_login, project_cipher, state_description|
  user = User.find_by_login(user_login)
  project = Project.find_by_cipher(project_cipher)
  manager = Manager.find_by_user_id_and_project_id(user.id, project.id)
  assert_equal get_manager_state(state_description), manager.state, "Не верное состояние руководителя проекта"
end

Then /^мне (запрещ\w+|разреш\w+) утверждение действия над руководителем проекта\s*(.*)$/ do |permission, match|
  manager = create_project_manager(match, "awaiting_approval");
  visit approve_chair_project_manager_url(manager.project.chair, manager.project, manager), :put
  manager = Manager.find_by_id(manager.id)
  if allow?(permission)
    assert manager.approved?, "не могу утвердить действие над руководителем"
  else
    assert manager.awaiting_approval?, "могу утвердить действие над руководителем"
  end
end

Then /^мне (запрещ\w+|разреш\w+) отмена действия над руководителем проекта\s*(\w+-\d+)?(?: в состоянии "(.*)")?$/ do |permission, match, state|
  state ||= "awaiting_approval"
  manager = create_project_manager(match, state);

  visit cancel_chair_project_manager_url(manager.project.chair, manager.project, manager), :put

  manager = Manager.find_by_id(manager.id)

  if allow?(permission)
    if (state == "awaiting_approval")
      assert manager.nil?, "руководитель проекта должен был удалиться"
    else
      assert manager.approved?, "руководитель проекта должен быть восстановлен"
    end
  end

  if deny?(permission)
    assert_equal state, manager.state, "могу отменить действие над руководителем проекта"
  end
end

Then /^пользователь (\w+) (не)?\s*является руководителем проекта\s*(\w+-\d+)?$/ do |user_login, no, project_cipher|
  user = User.find_by_login(user_login)
  project = Project.find_by_cipher(project_cipher)
  manager = Manager.find_by_user_id_and_project_id(user.id, project.id)
  if no.nil?
    assert !manager.nil?, "пользователь #{user.login} не является руководителем проекта #{project.cipher}"
  else
    assert manager.nil?, "пользователь #{user.login} является руководителем проекта #{project.cipher}"
  end
end

Then /^пользователь (\w+) не является руководителем$/ do |user_login|
  user = User.find_by_login(user_login)
  assert user.projects.empty?, "пользователь является руководителем какого-то проекта"
end

Then /^у руководителя "(\w+)" (есть|нет) действи\w+ "(\w+)"$/ do |last_name, condition, button_name|
  expected_to_found = (condition == "есть")
  found = expected_to_found
  Nokogiri::HTML(response.body).search(".odd").each do |element|
    found = element.to_s.include?(last_name) && element.to_s.include?(button_name)
    break if found
  end
  if expected_to_found
    assert found, "у #{last_name} должно быть действие #{button_name}"
  else
    assert !found, "у #{last_name} не должно быть действие #{button_name}"
  end
end
