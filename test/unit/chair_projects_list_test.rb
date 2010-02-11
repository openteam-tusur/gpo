require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairProjectsListTest < Test::Unit::TestCase
  def students(chel)
    {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true},
      :petrov => {:id => 222, :last_name => "Петров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "3", :chair_abbr => "АСУ", :active => true, :gpo => true}
    }.fetch(chel)
  end


  def test_render_valid_data
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
      # поиск по Петрова по contingent_id
      mock.get "/students/222.xml", {}, students(:petrov).to_xml(:root => "student")
    end
    Chair.destroy_all
    Project.destroy_all
    Participant.destroy_all
    chair = Factory(:chair, :chief => "Ехлаков Ю.П.")
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

    order = Factory("OpeningOrder", :chair => chair, :projects => [project])
    order.number = "111"
    order.approved_at = "23.12.2008"
    order.state = 'approved'
    order.save(false)

    order1 = Factory("WorkgroupOrder", :chair => chair, :projects => [project])
    order1.number = "222"
    order1.approved_at = "23.01.2009"
    order1.state = 'approved'
    order1.save(false)

    order2 = Factory("WorkgroupOrder", :chair => chair, :projects => [project])
    order2.number = "333"
    order2.approved_at = "23.02.2009"
    order2.state = 'approved'
    order2.save(false)

    order3 = Factory("WorkgroupOrder", :chair => chair, :projects => [project])


    report = ChairProjectsList.new(chair)


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(1, 'A').include?(chair.abbr), "аббревиатура каф"
      index = 3
      chair.projects.each do |project|
        assert_equal project.cipher,  oo.cell(index, 'A'), "шифр"
        assert_equal project.title,  oo.cell(index, 'B'), "название проекта"
        assert_equal "#{user1.name}, #{user2.name}",  oo.cell(index, 'C'), "манагер"
        assert_equal "Формирование №#{order.number} от #{order.approved_at} Изменение состава гр. №333 от 23.02.2009, №222 от 23.01.2009",  oo.cell(index, 'H'), "приказ"
        i = 1
        project.participants.active.each do |participant|
          assert_equal i.to_s,  oo.cell(index, 'D'), "номер студента"
          assert_equal participant.name,  oo.cell(index, 'E'), "студент"
          assert_equal participant.course.to_s,  oo.cell(index, 'F'), "курс студента"
          assert_equal participant.edu_group,  oo.cell(index, 'G'), "группа"
          index += 1
          i += 1
        end
      end
    end
  end
end
