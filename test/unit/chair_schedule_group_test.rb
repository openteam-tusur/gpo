require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairScheduleGroupTest < Test::Unit::TestCase
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


    report = ChairScheduleGroup.new(chair)


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(2, 'G').include?(chair.abbr), "аббревиатура каф"
      assert oo.cell(3, 'G').include?(chair.chief), "зав каф"
      assert oo.cell(4, 'G').include?(Date.today.year.to_s), "текущий год"
      assert oo.cell(5, 'A').include?(report.semestr), "тип семестра"
      assert oo.cell(5, 'A').include?(report.edu_years), "учебный год"
      index = 7
      chair.projects.each do |project|
        assert_equal project.cipher,  oo.cell(index, 'A'), "шифр"
        assert_equal "#{user1.name}, #{user2.name}",  oo.cell(index, 'B'), "манагер"
        assert_equal "Четверг с 8.50 до 14.50",  oo.cell(index, 'H'), "время занятий"
        i = 1
        project.participants.active.each do |participant|
          assert_equal i.to_s,  oo.cell(index, 'C'), "номер студента"
          assert_equal participant.name,  oo.cell(index, 'D'), "студент"
          assert_equal participant.course.to_s,  oo.cell(index, 'E'), "курс студента"
          assert_equal participant.edu_group,  oo.cell(index, 'F'), "группа"
          index += 1
          i += 1
        end
      end
    end
  end
end
