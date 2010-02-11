def valid_stage_attributes(project, title = nil)
  {:stage => {:title => title || "название этапа", :project_id => project.id, :start => "20.12.2008", :finish => "20.12.2009"}}
end

Given /^в базе существуют следующие этапы$/ do |table|
  Stage.transaction do
    Stage.destroy_all
    table.hashes.each do |stage|
      stage = stage.dup
      project_cipher = stage.delete("project")
      stage[:project] = find_or_create_project(project_cipher)
      Factory(:stage, stage)
    end    
  end
end

Given /^у проекта ([^\s]+) нет этапов$/ do |cipher|
  project = find_or_create_project(cipher)
  project.stages.destroy_all
end

Then /^у проекта ([^\s]+) есть (\d+) этап/ do |cipher, count|
  project = find_or_create_project(cipher)
  assert_equal count.to_i, project.stages.count, "у проекта #{cipher} не #{count}, а #{project.stages.count} этапов"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit chair_project_stages_url(project.chair, project), permission, "могу просмотреть календарный план проекта кафедры #{project.chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  stage = Factory(:stage, :project => project)
  can_visit chair_project_stage_url(project.chair, project, stage), permission, "могу просмотреть этап календарного плана проекта #{project.cipher}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы создания этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit new_chair_project_stage_url(project.chair, project), permission, "могу просмотреть форму добавления этапа календарного плана проекта #{project.cipher}"
end

Then /^мне (запрещ\w+|разреш\w+) создание этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  assert_create_allowed(project.stages, chair_project_stages_url(project.chair, project),
    valid_stage_attributes(project), permission, "могу создать этап календарного плана проекта #{project.cipher}")
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы редактирования этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  stage = Factory(:stage, :project => project)
  can_visit edit_chair_project_stage_url(project.chair, project, stage), permission, "могу просмотреть форму редактирования этапа календарного плана проекта #{project.cipher}"
end

Then /^мне (запрещ\w+|разреш\w+) обновление этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  stage = Factory(:stage, :project => project)
  title = stage.title
  visit chair_project_stage_url(project.chair, project, stage), :put, valid_stage_attributes(project, :title => "новый заголовок этапа")
  assert_update_allowed(stage.title, Stage.find(stage.id).title, permission, "могу обновить этап календарного плана проекта #{project.cipher}")
end

Then /^мне (запрещ\w+|разреш\w+) удаление этапа календарного плана проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  stage = Factory(:stage, :project => project)
  assert_delete_allowed(project.stages, chair_project_stage_url(project.chair, project, stage), permission, "могу удалить этап календарного плана проекта кафедры #{project.cipher}")
end
