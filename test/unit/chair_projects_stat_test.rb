require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairProjectsStatTest < Test::Unit::TestCase
  def students(chel)
    {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true},
      :petrov => {:id => 222, :last_name => "Петров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "3", :chair_abbr => "АСУ", :active => true, :gpo => true},
      :sidorov => {:id => 333, :last_name => "Сидоров", :first_name => "Сидор", :mid_name => "Сидорович", :edu_group => "436", :year => "5", :chair_abbr => "ТУ", :active => true, :gpo => true}
    }.fetch(chel)
  end


  def test_render_valid_data
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
      mock.get "/students/222.xml", {}, students(:petrov).to_xml(:root => "student")
      mock.get "/students/333.xml", {}, students(:sidorov).to_xml(:root => "student")
    end
    chair = Factory(:chair, :abbr => "abbr", :chief => "Ехлаков Ю.П.")
    project = Factory(:project, :cipher => "АОИ-0701", :title => "Пирожковый автомат", :chair => chair)
    project.state = 'active'
    project.save(false)
    user1 = Factory(:user, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович")
    user2 = Factory(:user, :last_name => "Петров", :first_name => "П.", :mid_name => "П.")
    Factory(:manager, :project => project, :user => user1)
    Factory(:manager, :project => project, :user => user2)

    participant1 = Factory(:participant, :project => project, :student => Student.find(111))
    participant1.state = 'approved'
    participant1.save(false)
    participant2 = Factory(:participant, :project => project, :student => Student.find(222))
    participant2.state = 'approved'
    participant2.save(false)
    participant3 = Factory(:participant, :project => project, :student => Student.find(333))
    participant3.state = 'approved'
    participant3.save(false)


    report = ChairProjectsStat.new(chair)


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(1, 'A').include?(chair.abbr), "аббревиатура каф"
      index = 3
      chair.projects.each do |project|
        assert_equal "#{index - 2}.",  oo.cell(index, 'A'), "№ пп"
        assert_equal project.cipher,  oo.cell(index, 'B'), "шифр"
        assert_equal project.title,  oo.cell(index, 'C'), "название проекта"
        assert_equal "#{user1.name}, #{user2.name}",  oo.cell(index, 'D'), "манагер"
        assert_equal 1.0,  oo.cell(index, 'E'), "кол-во студентов 3"
        assert_equal 1.0,  oo.cell(index, 'F'), "кол-во студентов 4"
        assert_equal 1.0,  oo.cell(index, 'G'), "кол-во студентов 5"
        assert_equal 3.0,  oo.cell(index, 'H'), "кол-во студентов всего"
        index += 1
      end
    end
  end
end
