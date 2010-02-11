Given /^у студента (\w+) установлен(?:\w)? (\d) балл(?:\w)? за посещаемость в (\d)-\w+ день ГПО$/ do |student_name, rate, day_index|
  participant = Participant.find_by_student_id(students(student_name.to_sym)[:id])
  gpoday = Gpoday.find(:all, :order => :date)[day_index.to_i-1]
  visitation = participant.visitation_for_gpoday(gpoday)
  visitation.rate = rate.to_i
  visitation.save
end

Given /^я на странице журнала посещаемости проекта (.*)$/ do |project_cipher|
  project = find_or_create_project(project_cipher)
  visit chair_project_visitations_url(project.chair, project)
end

Then /^мне (\w+) просмотр посещаемости проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  visit chair_project_url(project.chair, project)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Посещаемость"}
  visit chair_project_visitations_url(project.chair, project)
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) изменение балла посещаемости студентов проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  participant = project.participants.active[0]
  gpoday = Gpoday.first
  visit edit_chair_project_visitation_url(project.chair, project, gpoday)
  Then "мне должно быть #{permission}"
  put chair_project_visitation_url(project.chair, project, gpoday), :participant => {participant.id => 0.5}
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) просмотр посещаемости кафедры (\w+)$/ do |permission, abbr|
  chair = find_or_create_chair(abbr)
  visit chair_url(chair)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Посещаемость"}
  visit chair_visitations_url(chair)
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) просмотр посещаемости университета$/ do |permission|
  visit visitations_url
  Then "мне должно быть #{permission}"
end

