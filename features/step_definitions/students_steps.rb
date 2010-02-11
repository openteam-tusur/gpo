def students(chel)
  {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true},
    :petrov => {:id => 222, :last_name => "Петров", :first_name => "Петр", :mid_name => "Петрович", :edu_group => "406", :year => "3", :chair_abbr => "АСУ", :active => true, :gpo => true},
    :sidorov => {:id => 333, :last_name => "Сидоров", :first_name => "Сидор", :mid_name => "Сидорович", :edu_group => "436", :year => "5", :chair_abbr => "ТУ", :active => true, :gpo => true}
  }.fetch(chel)
end

def updated_contingent_students(chel)
  {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "3", :chair_abbr => "АОИ", :active => true, :gpo => false},
    :petrov => {:id => 222, :last_name => "Петров", :first_name => "Петр", :mid_name => "Петрович", :edu_group => "406", :year => "3", :chair_abbr => "АСУ", :active => false, :gpo => true},
    :sidorov => {:id => 333, :last_name => "Сидоров", :first_name => "Сидор", :mid_name => "Сидорович", :edu_group => "436", :year => "2", :chair_abbr => "ТУ", :active => false, :gpo => false}
  }.fetch(chel)
end

Given /^в контингенте существуют студенты$/ do
  require "active_resource"
  require "active_resource/http_mock"
  #@petrov = {:id => 2, :last_name => "Петров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "3"}
  ActiveResource::HttpMock.respond_to do |mock|
    mock.get "/students.xml", {}, [].to_xml()
    # поиск третьекурсника по contingent_id
    mock.get "/students/3.xml", {}, students(:petrov).to_xml(:root => "student")
    # поиск четверокурсника по contingent_id
    mock.get "/students/4.xml", {}, students(:ivanov).to_xml(:root => "student")
    # поиск пятикурскника по contingent_id
    mock.get "/students/5.xml", {}, students(:sidorov).to_xml(:root => "student")
    # поиск по Иванова по contingent_id
    mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
    mock.put "/students/111.xml", {}, students(:ivanov)
    # поиск по Петрова по contingent_id
    mock.get "/students/222.xml", {}, students(:petrov).to_xml(:root => "student")
    mock.put "/students/222.xml", {}, students(:petrov)
    # поиск по Сидорова по contingent_id
    mock.get "/students/333.xml", {}, students(:sidorov).to_xml(:root => "student")
    mock.put "/students/333.xml", students(:sidorov), nil, 204
    # поиск по фамилии Иванов => Иванов
    mock.get "/students.xml?last_name=%D0%98%D0%B2%D0%B0%D0%BD%D0%BE%D0%B2", {}, [students(:ivanov)].to_xml(:root => "students")
    # поиск по группе 405 => Иванов
    mock.get "/students.xml?edu_group=405", {}, [students(:ivanov)].to_xml(:root => "students")
    # поиск по группе 406 => Петров
    mock.get "/students.xml?edu_group=406", {}, [students(:petrov)].to_xml(:root => "students")
    # поиск по группе 406 и фамилии Иванов => пусто
    mock.get "/students.xml?edu_group=406&last_name=%D0%98%D0%B2%D0%B0%D0%BD%D0%BE%D0%B2", {}, [].to_xml
    # поиск по группе 405 и фамилии Иванов => Иванов
    mock.get "/students.xml?edu_group=405&last_name=%D0%98%D0%B2%D0%B0%D0%BD%D0%BE%D0%B2", {}, [students(:ivanov)].to_xml(:root => "students")
  end
end

When /^в контингенте обновились сведения о студентах$/ do
  require "active_resource"
  require "active_resource/http_mock"
  ActiveResource::HttpMock.respond_to do |mock|
    # поиск третьекурсника по contingent_id
    mock.get "/students/3.xml", {}, students(:petrov).to_xml(:root => "student")
    # поиск четверокурсника по contingent_id
    mock.get "/students/4.xml", {}, students(:ivanov).to_xml(:root => "student")
    mock.get "/students/111.xml", {}, updated_contingent_students(:ivanov).to_xml(:root => "student")
    # поиск по Петрова по contingent_id
    mock.get "/students/222.xml", {}, updated_contingent_students(:petrov).to_xml(:root => "student")
    # поиск по Сидорова по contingent_id
    mock.get "/students/333.xml", {}, updated_contingent_students(:sidorov).to_xml(:root => "student")
  end
end

Then /мне (запрещ\w+|разреш\w+) просмотр списка студентов/ do |permission|
  can_visit students_url, permission, "вижу список студентов"
end

Then /мне (запрещ\w+|разреш\w+) просмотр списка проблемных студентов/ do |permission|
  can_visit problematic_students_url, permission, "вижу список проблемных студентов"
end

