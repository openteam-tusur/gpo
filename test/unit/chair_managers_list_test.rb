require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairManagersListTest < Test::Unit::TestCase
  def students(chel)
    {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true},
    }.fetch(chel)
  end


  def test_render_valid_data
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
    end
    Chair.destroy_all
    Project.destroy_all
    Participant.destroy_all
    chair = Factory(:chair, :chief => "Ехлаков Ю.П.")
    project = Factory(:project, :cipher => "АОИ-0701", :title => "Пирожковый автомат", :chair => chair)
    project.state = 'active'
    project.save(false)
    user1 = Factory(:user, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :email => "mail@openteam.ru")
    manager = Factory(:manager, :project => project, :user => user1)
    manager.state = 'approved'
    manager.save(false)

    participant1 = Factory(:participant, :project => project, :student => Student.find(111))
    participant1.state = 'approved'
    participant1.save(false)

    report = ChairManagersList.new(chair)


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(1, 'A').include?(chair.abbr), "аббревиатура каф"
      index = 4
      i = 1
      chair.managers.each do |manager|
        assert_equal i.to_s,  oo.cell(index, 'A'), "№пп"
        assert_equal manager.name,  oo.cell(index, 'B'), "ФИО руководителя"
        assert_equal project.cipher,  oo.cell(index, 'C'), "№ группы ГПО"
        assert_equal manager.post,  oo.cell(index, 'D'), "Должность, уч. звание"
        assert_equal manager.float,  oo.cell(index, 'E'), "Аудитория"
        assert_equal manager.phone,  oo.cell(index, 'F'), "Аудитория"
        assert_equal manager.email,  oo.cell(index, 'G'), "Адрес электронной почты"
        index += 1
        i += 1
      end
    end
  end
end
