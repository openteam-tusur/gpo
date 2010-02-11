Given /^для студента "([^\"]*)" заведена задача "([^\"]*)" с плановой датой завершения "([^\"]*)" и плановым количеством баллов "([^\"]*)"$/ do |student_ident, issue_name, issue_planned_closing_id, issue_planned_grade|
  participant = Participant.find_by_student_id(students(student_ident.to_sym)[:id])
  Factory.create(:issue, :participant => participant, :name => issue_name, :planned_closing_at => issue_planned_closing_id, :planned_grade => issue_planned_grade)
end

When /^я на странице индивидуальных задач проекта "([^\"]*)"$/ do |project_cipher|
  project = Project.find_by_cipher(project_cipher)
  visit chair_project_issues_path(project.chair, project)
end

Then /^мне (\w+) просмотр индивидуальных планов участников проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  visit chair_project_url(project.chair, project)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Индивидуальные задачи"}
  visit chair_project_issues_url(project.chair, project)
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) добавление индивидуальной задачи для участника проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  participant = project.participants.active.first
  visit chair_project_issues_url(project.chair, project)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Добавить"}
  visit new_chair_project_participant_issue_url(project.chair, project, participant)
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) изменение индивидуальной задачи для участника проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  participant = project.participants.active.first
  visit chair_project_issues_url(project.chair, project)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Редактировать"}
  visit edit_chair_project_participant_issue_url(project.chair, project, participant, participant.issues.first)
  Then "мне должно быть #{permission}"
end

Then /^мне (\w+) удаление индивидуальной задачи для участника проекта (.*)$/ do |permission, project|
  project = find_or_create_project(project)
  participant = project.participants.active.first
  visit chair_project_issues_url(project.chair, project)
  Then %{я #{allow?(permission)? "вижу" : "не вижу"} "Удалить"}
  delete chair_project_participant_issue_url(project.chair, project, participant, participant.issues.first)
  Then "мне должно быть #{permission}"
end

