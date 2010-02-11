def find_or_create_chair(abbr = nil)
  abbr ||= "АОИ"
  Chair.find_by_abbr(abbr) || Factory(:chair, :abbr => abbr)
end

def find_or_create_chair_by_match(match = "")
  match = match.blank? ? "на кафедре АОИ": match
  if /(\w+)-(\w+)/ =~ match
    abbr = match.split("-")[0].strip
  else
    abbr = match.gsub(/(на )?кафедр[^\s]+/, "").strip
  end
  Chair.find_by_abbr(abbr) || Factory(:chair, :abbr => abbr)
end

Given /^в базе существуют следующие кафедры$/ do |table|
  table.hashes.each do |chair|
    Factory(:chair, chair)
  end
end

Given /^существуют кафедры (.*)$/ do |chair_abbrs|
  chair_abbrs.split(", ").each do |abbr|
    chair = find_or_create_chair(abbr)
  end
end

Given /^я на странице кафедры (\w+)$/ do | abbr |
  chair = find_or_create_chair(abbr)
  visit chair_url(chair)
end

Given /^в базе нет кафедр$/ do
  Chair.destroy_all
end

Then /^в базе ровно (\d+) кафедра$/ do |num|
  assert_equal num.to_i, Chair.count
end

Then /мне (запрещ\w+|разреш\w+) просмотр списка кафедр/ do |permission|
  can_visit chairs_url, permission, "вижу список кафедр"
end

Then /мне запрещен просмотр формы создания кафедры/ do
  visit new_chair_url
  assert_not_allowed "вижу форму создания кафедры"
end

Then /мне запрещено создание кафедры/ do
  chair = Factory.attributes_for(:chair)
  count = Chair.count
  visit chairs_url, :post, {:chair => chair}
  assert_equal count, Chair.count, "могу создать кафедру"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр кафедры\s*(.*)$/ do |permission, abbr|
  abbr = abbr.blank? ? nil : abbr
  chair = find_or_create_chair(abbr)
  can_visit chair_url(chair), permission, "могу просмотреть кафедру #{chair.abbr}"
end

Then /мне (запрещ\w+|разреш\w+) просмотр списка руководителей кафедры\s*(.*)$/ do |permission, abbr|
  abbr = abbr.blank? ? nil : abbr
  chair = find_or_create_chair(abbr)
  can_visit managers_chair_url(chair), permission, "могу просмотреть руководителей кафедры #{chair.abbr}"
end

Then /мне запрещен просмотр формы редактирования кафедры/ do
  chair = Factory(:chair)
  visit edit_chair_url(chair)
  assert_not_allowed "могу просмотреть форму редактирования кафедры"
end

Then /мне запрещено обновление кафедры/ do
  chair = find_or_create_chair('АОИ')
  visit chair_url(chair), :put, {:chair => Factory.attributes_for(:chair, :abbr => 'А-О-И')}
  assert_equal Chair.find(chair.id).abbr, chair.abbr, "могу обновить кафедру"
end

Then /мне запрещено удаление кафедры/ do
  chair = Factory(:chair)
  count = Chair.count
  visit chair_url(chair), :delete
  assert_equal count, Chair.count, "могу удалить кафедру"
end

