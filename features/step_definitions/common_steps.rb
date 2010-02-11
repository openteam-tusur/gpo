def assert_not_allowed(msg = nil)
  check_errors_after_visit("запрещено", msg)
end

def allow?(permission)
  permission =~ /разр/
end

def deny?(permission)
  !allow?(permission)
end

def can_visit(url, permission, msg)
  visit url
  check_errors_after_visit(permission, msg)
end

def assert_create_allowed(objects, url, valid_attributes, permission, message)
  count = objects.count
  visit url, :post, valid_attributes
  if allow?(permission)
    count = count + 1
    message = "не #{message}"
  end
  assert_equal count, objects.count, message
end

def assert_delete_allowed(objects, url, permission, message)
  count = objects.count
  visit url, :delete
  if allow?(permission)
    count = count - 1
    message = "не #{message}"
  end
  assert_equal count, objects.count, message
end

def current_user
  User.find(session[:user_id]) rescue nil
end

Then /^я вижу заголовок "(.*)"$/ do |title|
  assert_have_selector('title', {:content => "#{title}"})
end

Then /^я вижу форму ввода$/ do
  assert_have_selector('form')
end

Then /^я не вижу форму ввода$/ do
  assert_have_no_selector('form')
end

Then /^не должно быть ошибок$/ do
  assert_have_no_selector('#errorExplanation')
end

Then /^должны быть ошибки$/ do
  assert_have_selector('#errorExplanation')
end

Then /^я (вижу|не вижу) элемент с текстом "(.*)" и "(.*)"$/ do |condition, text1, text2|
  expected_to_found = (condition == "вижу")
  found = false
  current_dom.search("li,h1,tr").each do |element|
    found = element.to_str.match(text1) && element.to_str.match(text2)
    break if found
  end
  if expected_to_found
    assert found, "Должен быть текст '#{text1}' и '#{text2}', а нету"
  else
    assert !found, "Не должно быть '#{text1}' и '#{text2}', а они есть"
  end
end

Then /^я вижу выпадающий список "(.*)" (с|без) элемент\w+ "(.*)"$/ do |field, condition ,value|
  expected_to_found = (condition == 'с')
  founded = false
  field_labeled(field).element.children.each do |option|
    founded = true if option.to_s.match("#{value}")
  end
  if expected_to_found
    assert founded, "Искали элемент '#{value}' выпадающего списка '#{field}', а не нашли"
  else
    assert !founded, "Не должны были найти элемент '#{value}' выпадающего списка '#{field}', и почему то нашли"
  end
end

Then /^я не вижу выпадающий список "(.*)"$/ do |label|
  element = field_labled(label, Webrat::SelectField) rescue nil
  assert_equal nil, element, "Не должны были найти выпадающий список, а нашли #{label}"
end

Then /^я (вижу|не вижу) кнопку "(.*)"$/ do |condition, button_text|
  expected_to_found = (condition == "вижу")
  button = current_dom.search("input[type='submit'][value='#{button_text}']").first
  if expected_to_found
    assert button, "Искали кнопку '#{button_text}', а не нашли"
  else
    assert_equal nil, button, "Не должны были найти кнопку '#{button_text}', а почему то нашли"
  end
end

Then /^выбран чекбокс "(.*)"$/ do |name_or_label|
  check_box = field_labeled(name_or_label)
  assert check_box.checked?, "чекбокс #{name_or_label} не выбран"
end

Then /^не выбран чекбокс "(.*)"$/ do |name_or_label|
  check_box = field_labeled(name_or_label)
  assert !check_box.checked?, "чекбокс #{name_or_label} выбран"
end

When /^я перехожу по ссылке главного меню "(.*)"$/ do |link|
  click_link_within('#header-navigation', link)
end

When /^я перехожу по ссылке в подменю "(.*)"$/ do |link|
  click_link_within('#navigation', link)
end

When /^я перехожу по ссылке в локальном меню "(.*)"$/ do |link|
  click_link_within('#local-navigation', link)
end

Then /^я не вижу в главном меню ссылку "(.*)"$/ do |text|
  assert_have_no_selector("#top_navigation ul > li:contains('#{text}')")
end

When /^я перехожу по ссылке удаления "(.*)"$/ do |link|
  click_link link, :method => :delete
end

Then /^от сервера должен прийти (\w+) документ$/ do |format|
  assert_equal Mime::Type.lookup_by_extension(format), response.content_type, "неверный ответ сервера"
end


Then /^не вижу поля ввода "(.*)"$/ do |label|
  text_field = field_labeled(label, Webrat::TextField) rescue nil
  assert text_field.nil?, "есть поле ввода #{name}"
end

Then /^вижу поле ввода "(.*)"$/ do |name_or_label|
  text_field = field_labeled(name_or_label, Webrat::TextField) rescue nil
  assert !text_field.nil?, "нет поля ввода #{name_or_label}"
end

Then /^есть (?:нотис|уведомление|notice) "(.*)"$/ do |text|
  assert_equal text, flash[:notice], "flash[:notice] не содержит #{text}"
end

Then /^есть (?:ошибка) "(.*)"$/ do |text|
  assert_equal text, flash[:error], "flash[:error] не содержит #{text}"
end

def check_errors_after_visit(permission, msg)
  Then "мне должно быть #{permission}"
end

Then /^мне должно быть разреш\w+$/ do
  assert response.code != "403"
end

Then /^мне должно быть запре\w+$/ do
  assert response.code == "403"
end


Then /^в строке (\d+) списка "([^\"]*)" я вижу "([^\"]*)"$/ do |num, list, value|
  current_dom.search("#{list}>li[#{num}]").should contain(value)
end

Then /^я должен быть перенаправлен на странице входа в систему$/ do
  response.location.should eql(login_url)
end

