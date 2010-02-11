def find_or_create_user(login = nil, chair = nil)
  login ||= "login"
  User.find_by_login(login) || Factory(:user, :login => login, :chair => chair)
end


Given /^я не вхожу в систему$/ do
  visit logout_url
end

Given /^я вхожу в систему как аноним$/ do
  Given "я не вхожу в систему"
end

Given /^я вхожу в систему как администратор$/ do
  user = Factory(:user, :last_name => "Суперзверев", :first_name => "Админ", :mid_name => "Рутович", :login => "admin")
  rule = Factory(:rule_admin, :user => user)
  login_as user.login, user.password
end

Given /^я вхожу в систему как супервизор$/ do
  user = Factory(:user)
  rule = Factory(:rule_supervisor, :user => user)
  login_as user.login, user.password
end

Given /^я вхожу в систему как пользователь$/ do
  user = Factory(:user)
  login_as user.login, user.password
end

Given /^я вхожу в систему как ментор кафедры (\w+)$/ do |chair_abbr|
  chair = find_or_create_chair(chair_abbr)
  user = Factory(:user, :chair => chair)
  rule = Factory(:rule_mentor, :user => user, :context => chair)
  login_as(user.login, user.password)
end

Given /^я вхожу в систему как ментор кафедр (.*)$/ do |abbrs|
  user = Factory(:user)
  abbrs.split(",").each { |abbr|
    abbr.strip!
    chair = find_or_create_chair(abbr)
    Factory(:rule_mentor, :user => user, :context => chair)
  }
  login_as(user.login, user.password)
end

Given /^я вхожу в систему как руководитель проекта(?: ([^\s]+))?$/ do |project_cipher|
  project = find_or_create_project(project_cipher)
  user = Factory(:user, :chair => project.chair)

  manager = Factory(:manager, :user => user, :project => project)
  manager.approve
  manager.save(false)

  login_as(user.login, user.password)
end

Given /^я вхожу в систему как руководитель проектов (.*)$/ do |ciphers|
  user = Factory(:user)
  ciphers.split(",").each { |cipher|
    cipher.strip!
    chair = find_or_create_chair(cipher.split("-")[0])
    project = find_or_create_project(cipher, chair)

    manager = Factory(:manager, :user => user, :project => project)
    manager.approve
    manager.save(false)
  }
  login_as(user.login, user.password)
end

Given /^я вхожу в систему как неутвержденный руководитель проекта(?: ([^\s]+))?$/ do |project_cipher|
  project = find_or_create_project(project_cipher)
  user = Factory(:user, :chair => project.chair)
  Factory(:manager, :user => user, :project => project)
  login_as(user.login, user.password)
end

Given /^я вхожу в систему как ижидающий удаления руководитель проекта(?: ([^\s]+))?$/ do |project_cipher|
  project = find_or_create_project(project_cipher)
  user = Factory(:user, :chair => project.chair)

  manager = Factory(:manager, :user => user, :project => project)
  manager.approve
  manager.remove
  manager.save(false)

  login_as(user.login, user.password)
end

def login_as(login, password)
  visit logout_url
  visit login_url
  fill_in "Логин", :with => login
  fill_in "Пароль", :with => password
  click_button "Войти"
  assert !have_selector('#error').matches?(response.body), "Ошибка при входе в систему"
end

Given /^я на странице списка пользователей кафедры (\w+)$/ do |chair_abbr|
  chair = find_or_create_chair(chair_abbr)
  visit chair_users_url(chair)
end


Given /^в базе существуют следующие пользователи$/ do |table|
  User.transaction do
    User.destroy_all
    table.hashes.each do |user|
      user = user.dup
      chair_abbr = user.delete("chair")
      user[:chair] = chair_abbr.blank? ? nil : (Chair.find_by_abbr(chair_abbr) || Factory(:chair, :abbr => chair_abbr))
      Factory(:user, user)
    end
  end
end

Given /в базе нет пользователей/ do
  User.destroy_all
end

Given /в базе (\d+) пользовател(ь|ей|я)/ do |n|
  User.transaction do
    User.destroy_all
    n.to_i.times { |n| Factory(:user) }
  end
end

Then /^в базе долж(ен|но) быть (\d+) пользовател(ь|ей|я)$/ do |s, num, e|
  assert_equal num.to_i, User.count
end

When /^я ввожу в форму следующие данные$/ do |table|
  table.hashes.each do |user|
    user.each_pair do |key, value|
      fill_in key, :with => value
    end
  end
end

Then /мне запрещен просмотр списка пользователей$/ do
  can_visit users_url, "запрещен", "могу просмотреть список пользователей системы"
end

Then /мне запрещен просмотр списка пользователей кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  can_visit chair_users_url(chair), "запрещен", "могу просмотреть список пользователей кафедр #{chair.abbr}"
end

Then /мне запрещен просмотр формы создания пользователя$/ do
  can_visit new_user_url, "запрещен", "могу просмотреть форму создания пользователя"
end

Then /мне запрещен просмотр формы создания пользователя кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  can_visit new_chair_user_url(chair), "запрещен", "могу просмотреть форму создания пользователя кафедры #{chair.abbr}"
end

Then /мне запрещено создание пользователя$/ do
  user = Factory.attributes_for(:user)
  count = User.count
  visit users_url, :post, {:user => user}
  assert_equal count, User.count, "могу создать пользователя"
end

Then /мне запрещено создание пользователя кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  user = Factory.attributes_for(:user, :chair => chair)
  count = chair.users.count
  visit chair_users_url(chair), :post, {:user => user}
  assert_equal count, chair.users.count, "могу создать пользователя на кафедре #{chair.abbr}"
end

Then /мне запрещен просмотр пользователя$/ do
  user = Factory(:user)
  visit user_url(user)
  assert_not_allowed "могу просмотреть пользователя"
end

Then /мне запрещен просмотр пользователя кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  user = Factory(:user, :chair => chair)
  visit chair_user_url(chair, user)
  assert_not_allowed "могу просмотреть пользователя на кафедре #{chair.abbr}"
end

Then /мне запрещен просмотр формы редактирования пользователя$/ do
  user = Factory(:user)
  visit edit_user_url(user)
  assert_not_allowed "могу просмотреть форму редактирования пользователя"
end

Then /мне запрещен просмотр формы редактирования пользователя кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  user = Factory(:user, :chair => chair)
  visit edit_chair_user_url(chair, user)
  assert_not_allowed "могу просмотреть форму редактирования пользователя на кафедре #{chair.abbr}"
end

Then /мне запрещено обновление пользователя$/ do
  user = Factory(:user, :first_name => "Иван")
  visit user_url(user), :put, {:user => Factory.attributes_for(:user, :first_name => "Вася")}
  assert_equal User.find(user.id).name, user.name, "могу обновить пользователя"
end

Then /мне запрещено обновление пользователя кафедры (\w+)/ do |abbr|
  chair = find_or_create_chair(abbr)
  user = Factory(:user, :first_name => "Иван", :chair => chair)
  visit chair_user_url(chair, user), :put, {:user => Factory.attributes_for(:user, :first_name => "Вася", :chair => chair)}
  assert_equal User.find(user.id).name, user.name, "могу обновить пользователя на кафедре #{chair.abbr}"
end

Then /^мне запрещено удаление пользователя\s*(\w+)?(?: на кафедре (\w+))?$/ do |user_login, chair_abbr|
  if chair_abbr.nil?
    user = find_or_create_user(user_login)
    count = User.count
    visit user_url(user), :delete
  else
    chair = find_or_create_chair(chair_abbr)
    user = find_or_create_user(user_login, chair)
    count = User.count
    visit chair_user_url(chair, user), :delete
  end
  assert_equal count, User.count, "могу удалить пользователя"
end

