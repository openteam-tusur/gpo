require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairAttestationTest < Test::Unit::TestCase
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
    chair = Factory(:chair, :abbr => "abbr", :chief => "Ехлаков Ю.П.")
    mentor = Factory(:user, :last_name => "Сидоров", :first_name => "Анатолий", :mid_name => "Васильевич")
    Factory(:rule_mentor, :user => mentor, :context => chair)
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

    report = ChairAttestation.new(chair)
    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(1, 'A').include?(chair.abbr), "аббревиатура каф"
      assert oo.cell(1, 'I').include?(chair.abbr), "аббревиатура каф"
      assert oo.cell(2, 'A').include?("Сидоров А.В."), "ответственный за ГПО на кафедре"
      assert oo.cell(2, 'I').include?(chair.chief), "зав. каф"
      assert oo.cell(5, 'A').include?(chair.abbr), "аббревиатура каф"
      assert oo.cell(5, 'A').include?(report.semestr), "тип семестра"
      assert oo.cell(5, 'A').include?(report.edu_years), "учебный год"
      assert oo.cell(4, 'I').include?(report.c_year), "текущий год"
      index = 7
      chair.projects.each do |project|
        assert oo.cell(index, 'A').include?(project.cipher), "шифр"
        assert oo.cell(index, 'A').include?(project.title), "название проекта"
        assert oo.cell(index, 'A').include?("#{user1.name}, #{user2.name}"), "манагер"
        i = 1
        project.participants.active.each do |participant|
          assert_equal i.to_s,  oo.cell(index, 'C'), "номер студента"
          assert_equal participant.name,  oo.cell(index, 'D'), "студент"
          assert_equal participant.course.to_s,  oo.cell(index, 'E'), "курс студента"
          assert_equal participant.edu_group,  oo.cell(index, 'F'), "группа"
          assert oo.formula(index, 'I').include?("G#{index}"), "рейтинг"
          assert oo.formula(index, 'J').include?("I#{index}"), "оценка ГПО"
          index += 1
          i += 1
        end
      end
    end
  end

end
