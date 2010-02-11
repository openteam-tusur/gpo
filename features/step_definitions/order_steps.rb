def valid_order_attributes(project, order_type = "Order")
  {:projects => [project.id], :type => order_type}
end

def get_order_state(state_description)
  case state_description
  when nil then state = 'draft'
  when "черновик" then state = 'draft'
  when "отправлен на визирование" then state = 'being_reviewed'
  when "визирован" then state = 'reviewed'
  when "утвержден" then state = 'approved'
  else raise "Неправильное состояние приказа"
  end
  state
end

def get_order_type(type_description = "о формировании проектов")
  case type_description
  when "об изменении рабочих групп"
    "WorkgroupOrder"
  when "о формировании проектов"
    "OpeningOrder"
  else
    raise "Неверный тип приказа"
  end
end

def find_or_create_order
  Order.find(:first) || create_order
end

def create_order(factory = "OpeningOrder", state_description = "черновик", matches = "АОИ-0701" )
  case factory
  when "WorkgroupOrder"
    project_state = "active"
  else
    project_state = "draft"
  end
  projects = []
  matches = matches + ","
  matches.split(",").each do |match|
    match.strip!
    unless match.blank?
      project = find_or_create_project_by_match(match)
      project.state = project_state
      project.save(false)
      projects << project
    end
  end
  order = Factory(factory, :chair => projects[0].chair, :projects => projects)
  order.state = get_order_state(state_description)
  order.save(false)
  order
end

def build_order_activity(order)
  case order.state
  when 'being_reviewed'
    order.activity!('to_review', current_user.name, 'комментарий')
  when 'reviewed'
    order.activity!('review', current_user.name, 'комментарий визирования')
  when 'approved'
    order.number = "111"
    order.approved_at = "23.12.2008"
    order.activity!('approve', current_user.name, '')
  end
  order.save!
end

Given /^в базе существует приказ (о формировании проектов|об изменении рабочих групп)(?:\s+проект\w+)? ((?:\w+-\d+(?:, )?)+)(?: в состоянии "(.+)")?( с записью об активности)?$/ do |type_description, matches, state_description, activity|
  order = create_order(get_order_type(type_description), state_description, matches)
  unless activity.blank?
    build_order_activity(order)
  end
end

Given /^я на странице приказа (о формировании проектов|об изменении рабочих групп)(?:\s+проект\w+)? ((?:\w+-\d+(?:, )?)+)(?: в состоянии "(.+)")?( с записью об активности)?$/ do |type_description, matches, state_description, activity|
  order = create_order(get_order_type(type_description), state_description, matches)
  unless activity.blank?
    build_order_activity(order)
  end
  visit chair_order_url(order.chair, order)
end

Then /^в базе долж\w+ быть (\d+) приказ\w* (\w+)$/ do |num, match|
  chair = find_or_create_chair_by_match(match)
  assert_equal num.to_i, chair.orders.count
end

Then /^в базе долж\w+ быть (\d+) приказ\w* кафедры (\w+)(?:\s*(о формировании проектов|об изменении рабочих групп))? в состоянии "(.+)"$/ do |num, match, type_description, state_description|
  chair = find_or_create_chair_by_match(match)
  case type_description
  when "OpeningOrder"
    orders = chair.opening_orders.find_all_by_state(get_order_state(state_description))
  when
    orders = chair.workgroup_orders.find_all_by_state(get_order_state(state_description))
  else
    orders = chair.orders.find_all_by_state(get_order_state(state_description))
  end
  assert_equal num.to_i, orders.length
end


Then /^мне (запрещ\w+|разреш\w+) просмотр списка приказов\s*(.*)$/ do |permission, matches|
  chair = find_or_create_chair_by_match(matches)
  can_visit chair_orders_url(chair), permission, "вижу список приказов #{chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  can_visit chair_order_url(order.chair, order), permission, "могу просмотреть приказ #{type_description} на кафедре #{chair_abbr}"
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы создания приказа\s*(о формировании проектов|об изменении рабочих групп)(?: на кафедре (.+))?$/ do |permission, type_description, chair_abbr|
  chair = find_or_create_chair_by_match(chair_abbr)
  can_visit new_chair_order_url(chair, :type => get_order_type(type_description)), permission, "могу просмотреть форму создания приказа"
end

Then /^мне (запрещ\w+|разреш\w+) создание приказа\s*(о формировании проектов|об изменении рабочих групп)(?: на кафедре (.+))?$/ do |permission, type_description, chair_abbr|
  chair = find_or_create_chair_by_match(chair_abbr)
  project = Factory(:project, :chair => chair)
  assert_create_allowed(project.chair.orders, chair_orders_url(project.chair),
    valid_order_attributes(project, get_order_type(type_description)), permission, "могу создать приказ")
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы редактирования приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  can_visit edit_chair_order_url(order.chair, order), permission, "могу просмотреть форму редактирования приказа"
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) обновление приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(черновик|отправлен на визирование|визирован)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  old_project = order.projects[0]
  project = Factory(:project, :chair => order.chair, :cipher => "АОИ-0901")
  visit chair_order_url(order.chair, order), :put,
    valid_order_attributes(project, get_order_type(type_description))

  if deny?(permission)
    assert_equal old_project, Order.find(order.id).projects[0], "могу обновить приказ"
  end
  if allow?(permission)
    assert Order.find(order.id).projects.include?(project), "не могу обновить приказ"
  end
  order.destroy
end
Then /^мне (запрещ\w+|разреш\w+) обновление приказа\s*(о формировании проектов|об изменении рабочих групп) в состоянии "утвержден"(?: на кафедре (.+))?$/ do |permission, type_description, chair_abbr|
  order = create_order(get_order_type(type_description), "утвержден", "#{chair_abbr}-0801")
  old_number = order.number
  visit chair_order_url(order.chair, order), :put, {:order => {:number => "123123", :approved_at => "26.12.2008"}}

  if deny?(permission)
    assert_equal old_number, Order.find(order.id).number, "могу обновить приказ"
  end
  if allow?(permission)
    assert_equal "123123", Order.find(order.id).number, "не могу обновить приказ"
  end
  order.destroy
end
Then /^мне (запрещ\w+|разреш\w+) отправка на визирование приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  visit update_state_chair_order_url(order.chair, order, {:to_review => "to_review"}), :put rescue
  if deny?(permission)
    assert_equal order.state, Order.find(order.id).state, "могу отправить приказ на визирование"
  end
  if allow?(permission)
    assert Order.find(order.id).being_reviewed?, "не могу отправить приказ на визирование"
  end
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) визирование приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  visit update_state_chair_order_url(order.chair, order, {:review => "review"}), :put rescue
  if deny?(permission)
    assert_equal order.state, Order.find(order.id).state, "могу визировать приказ"
  end
  if allow?(permission)
    assert Order.find(order.id).reviewed?, "не могу визировать приказ"
  end
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) утверждение приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  visit update_state_chair_order_url(order.chair, order,
    {:order => {:number => "23", :approved_at => "15.12.2008"}, :approve => "approve"}), :put rescue
  if deny?(permission)
    assert_equal order.state, Order.find(order.id).state, "могу утвердить приказ"
  end
  if allow?(permission)
    assert Order.find(order.id).approved?, "не могу утвердить приказ"
  end
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) возвращение приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  visit update_state_chair_order_url(order.chair, order,
    {:order => {:number => "23", :approved_at => "15.12.2008"}, :cancel => "cancel"}), :put rescue
  if deny?(permission)
    assert_equal order.state, Order.find(order.id).state, "могу вернуть приказ"
  else
    assert Order.find(order.id).draft?, "не могу вернуть приказ"
  end
  order.destroy
end

Then /^мне (запрещ\w+|разреш\w+) удаление приказа\s*(о формировании проектов|об изменении рабочих групп)(?: в состоянии "(.+)")?(?: на кафедре (.+))?$/ do |permission, type_description, state_description, chair_abbr|
  order = create_order(get_order_type(type_description), state_description, "#{chair_abbr}-0801")
  visit chair_order_url(order.chair, order), :delete
  if deny?(permission)
    assert Order.exists?(order.id), "могу удалить приказ"
  end
  if allow?(permission)
    assert !Order.exists?(order.id), "не могу удалить приказ"
  end
  order.destroy
end

Then /^у приказа\s*(\d+)? должен быть файл$/ do |number|
  order = number.nil? ? Order.find(:first) : Order.find_by_number(number)
  assert order.file?, "нету файла у приказа #{number}"
end

Then /^у приказа\s*(\d+)? не должно быть файла$/ do |number|
  order = number.nil? ? Order.draft.find(:first) : Order.find_by_number(number)
  assert !order.file?, "у приказа есть файл #{number}"
end

