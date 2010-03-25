require "active_resource"
require "active_resource/http_mock"

def students(chel)
  {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true},
    :petrov => {:id => 222, :last_name => "Петров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "3", :chair_abbr => "АСУ", :active => true, :gpo => true},
    :sidorov => {:id => 333, :last_name => "Сидоров", :first_name => "Сидор", :mid_name => "Сидорович", :edu_group => "436", :year => "5", :chair_abbr => "ТУ", :active => true, :gpo => true}
  }.fetch(chel)
end

ActiveResource::HttpMock.respond_to do |mock|
  mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
  mock.get "/students/222.xml", {}, students(:petrov).to_xml(:root => "student")
  mock.get "/students/333.xml", {}, students(:sidorov).to_xml(:root => "student")
end

Factory.define :participant do |participant|
  participant.student { | student | Student.find(111) }
  participant.project { | project | project.association(:project) }
  participant.state 'awaiting_approval'
end
