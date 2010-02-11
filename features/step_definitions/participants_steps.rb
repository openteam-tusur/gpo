def valid_participant_attributes (project, student)
  {:participant => {:project_id => project.id, :student_id => student.id}}
end

def create_project_participant(match, state="awaiting_approval")
  project = find_or_create_project_by_match(match)
  
  participant = Factory(:participant, :project => project, :student => Student.find(111))
  
  participant.state = state
  participant.save(false)

  participant
end

def check_participant_state_change(permission, match, initial_state, through_message, expected_state)
  participant = create_project_participant(match, initial_state);
  
  old_state = participant.state
  
  visit chair_project_participant_url(participant.project.chair, participant.project, participant), :put, 
    {:participant => {:state => through_message}}

  #check_errors_after_visit(permission, "могу послать запрос на обновление участника проекта")
  
  participant = Participant.find_by_id(participant.id)

  if allow?(permission)
    if (expected_state == "removed") 
      assert participant.nil?, "статус должен был измениться с #{old_state} на #{expected_state}"
    else
      assert_equal participant.state, expected_state, "статус должен был измениться с #{old_state} на #{expected_state}, а стал #{participant.state}"
    end
  end

  if deny?(permission) 
    assert_equal old_state, participant.state, "статус изменился с #{old_state} на #{participant.state}"
  end

end

def get_participant_state(state_description)
  case state_description
  when "Утверждён" then state = 'approved'
  else raise "Неправильное состояние проекта"
  end
end

Given /^в базе существуют следующие участники$/ do |table|
  Participant.destroy_all
  table.hashes.each do |participant|
    participant = participant.dup
    student_name = participant.delete("student")
    student = students(student_name.to_sym)
    
    participant[:student] = Student.find(student[:id])

    cipher = participant.delete("project")
    participant[:project] = find_or_create_project_by_match(cipher)
    
    state = participant.delete("state")

    p = Factory(:participant, participant)
    # проставить состояние и сохранить без валидации
    unless state.blank?
      p.state = state
      p.save(false)
    end
  end
end

Given /^в базе существуют (\d+) участников (\d) курса на кафедре (\w+)$/ do |count, course, chair_abbr|
  chair = find_or_create_chair(chair_abbr)
  # пока что забрасываем всех участников в один и тот же проект
  project = chair.projects.active.find(:first)
  count.to_i.times do
    p = Factory(:participant, :project => project, :student_id => course)
    p.approve
    p.save
  end
end

Given /^я на странице участников проекта\s*(.*)/ do |match|
  project = find_or_create_project_by_match(match)
  visit chair_project_participants_url(project.chair, project)
end

Then /^мне (запрещ\w+|разреш\w+) просмотр списка участников проекта\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit chair_project_participants_url(project.chair, project), permission,
    "могу просмотреть список участников проекта кафедры #{project.chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр формы включения участника в проект\s*(.*)$/ do |permission, match|
  project = find_or_create_project_by_match(match)
  can_visit new_chair_project_participant_url(project.chair, project), permission,
    "могу просмотреть форму добавления участника проекта кафедры #{project.chair.abbr}"
end

Then /^мне (запрещ\w+|разреш\w+) утверждение действия над участником проекта\s*(.*)$/ do |permission, match|
  participant = create_project_participant(match, "awaiting_approval");
  visit approve_chair_project_participant_url(participant.project.chair, participant.project, participant), :put
  participant = Participant.find_by_id(participant.id)
  if allow?(permission)
    assert participant.approved?, "не могу утвердить действие над участником"
  else
    assert participant.awaiting_approval?, "могу утвердить действие над участником"
  end
end

Then /^мне (запрещ\w+|разреш\w+) отмена действия над участником проекта\s*(\w+-\d+)?(?: в состоянии "(.*)")?$/ do |permission, match, state|
  state ||= "awaiting_approval"
  participant = create_project_participant(match, state)
  visit cancel_chair_project_participant_url(participant.project.chair, participant.project, participant), :put
  participant = Participant.find_by_id(participant.id)
  if allow?(permission)
    if (state == "awaiting_approval")
      assert participant.nil?, "участник проекта должен был удалиться"
    else
      assert participant.approved?, "участник проекта должен быть восстановлен"
    end
  end

  if deny?(permission)
    assert_equal state, participant.state, "могу отменить действие над участником проекта"
  end
end

Then /участник (.*) проекта (.*) должен быть в состоянии "(.*)"$/ do |student_name, project_cipher, state_description|
  student = students(student_name.to_sym)
  project = Project.find_by_cipher(project_cipher)
  participant = Participant.find_by_student_id_and_project_id(student[:id], project.id)
  assert_equal get_participant_state(state_description), participant.state, "Не верное состояние участника проекта"
end

Then /в проекте (.*) не должно быть участника (.*)$/ do |project_cipher, student_name|
  student = students(student_name.to_sym)
  project = Project.find_by_cipher(project_cipher)
  participant = Participant.find_by_student_id_and_project_id(student[:id], project.id)
  assert_equal nil, participant, "есть такой участник проекта"
end

Then /мне (запрещ\w+|разреш\w+) добавить в проект\s*(\w+-\d+)? студента\s*(\w+)?/ do |permission, project_cipher, student_name|
  student_name = student_name || "ivanov"
  student = students(student_name.to_sym)
  project = find_or_create_project(project_cipher)
  assert_create_allowed project.participants,
    chair_project_participants_url(project.chair, project),
    {:participant => {:project_id => project.id, :student_id => student[:id]}},
    permission,
    "могу создать участника проекта #{project.cipher}"
end

Then /мне (запрещ\w+|разреш\w+) исключение студента из проекта\s*(\w+-\d+)?$/ do |permission, project_cipher|
  participant = create_project_participant(project_cipher, "approved")

  old_count = participant.project.participants.count
  old_state = participant.state

  visit chair_project_participant_url(participant.project.chair, participant.project, participant), :delete

  assert_equal old_count, participant.project.participants.count

  participant = Participant.find_by_id(participant.id)

  assert (allow?(permission) && participant.awaiting_removal?) ||
    (deny?(permission) && participant.state == old_state)
end

Then /у участника (\w+) проекта (\w+-\d+) заполнена информация/ do |student_name, project_cipher|
  student = students(student_name.to_sym)
  project = find_or_create_project(project_cipher)
  participant = Participant.find_by_student_id_and_project_id(student[:id], project.id)
  assert_equal participant.first_name, participant.student.first_name, "имя не заполнено"
  assert_equal participant.mid_name, participant.student.mid_name, "отчество не заполнено"
  assert_equal participant.last_name, participant.student.last_name, "фамилия не заполнена"
  assert_equal participant.chair_abbr, participant.student.chair_abbr, "аббревиатура кафедры не заполнена"
  assert_equal participant.edu_group, participant.student.edu_group, "группа не заполнена"
  assert_equal participant.course, participant.student.course, "курс не заполнен"
  assert_equal participant.chair, project.chair, "кафедра проекта у участника не заполнено"
  assert_equal participant.contingent_active, participant.student.active, "флаг активности студента по контингенту не установлен"
  assert_equal participant.contingent_gpo, participant.student.gpo, "флаг участия в ГПО студента по контингенту не установлен"
end

When /система обновила информацию об участниках/ do
  Participant.update_from_contingent
end

Then /у участника (\w+) проекта (\w+-\d+) обновлена информация/ do |student_name, project_cipher|
  student = updated_contingent_students(student_name.to_sym)
  project = find_or_create_project(project_cipher)
  participant = Participant.find_by_student_id_and_project_id(student[:id], project.id)
  assert_equal participant.first_name, participant.student.first_name, "имя не заполнено"
  assert_equal participant.mid_name, participant.student.mid_name, "отчество не заполнено"
  assert_equal participant.last_name, participant.student.last_name, "фамилия не заполнена"
  assert_equal participant.chair_abbr, participant.student.chair_abbr, "аббревиатура кафедры не заполнена"
  assert_equal participant.edu_group, participant.student.edu_group, "группа не заполнена"
  assert_equal participant.course, participant.student.course, "курс не заполнен"
  assert_equal participant.chair, project.chair, "кафедра проекта у участника не заполнено"
  assert_equal participant.contingent_active, participant.student.active, "флаг активности студента по контингенту не установлен"
  assert_equal participant.contingent_gpo, participant.student.gpo, "флаг участия в ГПО студента по контингенту не установлен"
end

Then /^студент (\w+) не является участником$/ do |student_name|
  student = students(student_name.to_sym)
  participant = Participant.find_by_student_id(student[:id])
  assert participant.nil?, "студент является участником какого-то проекта"
end

Then /^у участника "(\w+)" (есть|нет) действи\w+ "(\w+)"$/ do |last_name, condition, button_name|
  expected_to_found = (condition == "есть")
  found = expected_to_found
  Nokogiri::HTML(response.body).search(".odd").each do |scope|
    found = scope.to_html.include?(last_name) && scope.to_html.include?(button_name)
    if found
      break
    end
  end
  if expected_to_found
    assert found, "у #{last_name} должно быть действие #{button_name}"
  else
    assert !found, "у #{last_name} не должно быть действие #{button_name}"
  end
end
