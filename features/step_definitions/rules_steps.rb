Given /^в базе существуют следующие правила$/ do |table|
  Rule.transaction do
    Rule.destroy_all
    table.hashes.each do |rule|
      rule = rule.dup
      user = User.find_by_login rule.delete("user")
      rule[:user] = user
      
      context_type = rule.delete("context")
      obj = rule.delete("object")
      case context_type
      when "chair"
        rule[:context] = find_or_create_chair(obj)
        Factory(:rule_mentor, rule)
      when "project"
        rule[:context] = find_or_create_project(obj)
        Factory(:rule_manager, rule)
      else
        Factory(:rule_admin, rule)
      end
    end
  end
end

def find_manager_rule(user_login, project_cipher)
  user = User.find_by_login(user_login)
  assert_not_nil user
  
  context = Project.find_by_cipher(project_cipher)
  assert_not_nil context
  
  rule = Rule.managers.for_project(context.id).for_user(user.id).find(:first)
end

Then /^в базе не должно быть правила для "(.*)" в роли руководителя проекта "(.*)"$/ do |user_login, project_cipher|
  assert_nil find_manager_rule(user_login, project_cipher)
end

Then /^в базе должно быть правило для "(.*)" в роли руководителя проекта "(.*)"$/ do |user_login, project_cipher|
  assert_not_nil find_manager_rule(user_login, project_cipher)
end

Then /^в базе должно быть правило для "(.*)" в роли ментора кафедры "(.*)"$/ do |user_login, chair_abbr|
  user = User.find_by_login(user_login)
  assert_not_nil user
  
  context = Chair.find_by_abbr(chair_abbr)
  assert_not_nil context
  
  rule = Rule.mentors.for_chair(context.id).for_user(user).find(:first)
  assert_not_nil rule
end

Then /^в базе не должно быть правила ментора кафедры (\w+)$/ do |chair_abbr|
  chair = find_or_create_chair(chair_abbr)
  rule = Rule.mentors.for_chair(chair.id).find(:first)
  assert_nil rule, "есть правило ментора кафедры #{chair.abbr}"
end

Then /^в базе должно быть правило для "(.*)" в роли администратора$/ do |user_login|
  user = User.find_by_login(user_login)
  assert_not_nil user
  
  rule = Rule.administrators.for_user(user).find(:first)
  assert_not_nil rule
end

Then /^в базе не должно быть правила супервизора$/ do
  assert Rule.supervisors.empty?, "есть правило супервизора"
end

Then /^в базе должно быть (\d+) правил(?:а|о) администратора$/ do |count|
  assert Rule.administrators.length == count.to_i
end


Then /^мне запрещ[её]н просмотр списка правил$/ do
  visit rules_url
  assert_not_allowed "вижу список правил"
end

Then /^мне запрещ[её]н просмотр формы создания правила$/ do
  visit new_rule_url
  assert_not_allowed "вижу форму создания правила"
end

Then /^мне запрещ[её]но создание правила$/ do
  count = Rule.count
  visit rules_url, :post, {:rule => Factory.attributes_for(:rule, :user_id => 1)}
  assert_equal count, Rule.count, "могу создать правило"
end

Then /^мне запрещ[её]н просмотр формы редактирования правила$/ do
  rule = Factory(:rule)
  visit edit_rule_url(rule)
  assert_not_allowed "могу просмотреть форму редактирования правила"
end

Then /мне запрещ[её]но обновление правила/ do
  user = Factory(:user)
  chair1 = Factory(:chair)
  chair2 = Factory(:chair)
  rule = Factory(:rule_mentor, :context => chair1, :user => user)
  visit rule_url(rule), :put, {:rule => Factory.attributes_for(:rule_mentor, :context => chair2, :user => user)}
  assert_equal Rule.find(rule.id).context_id, rule.context_id, "могу обновить правило"
end

Then /мне запрещ[её]но удаление правила(?: для (\w+))?$/ do |user_login|
  rule = nil
  if user_login.nil?
    rule = Factory(:rule)
  else
    user = find_or_create_user(user_login)
    rule = user.rules.find(:first)
  end
  count = Rule.count
  visit rule_url(rule), :delete
  assert_equal count, Rule.count, "могу удалить правило"
end
