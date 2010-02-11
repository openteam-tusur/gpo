require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ChairProjectsStatTest < Test::Unit::TestCase
  def students(chel)
    {:ivanov => {:id => 333, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "3", :chair_abbr => "АОИ", :active => true, :gpo => true},
      :petrov => {:id => 444, :last_name => "Петров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "406", :year => "4", :chair_abbr => "АСУ", :active => true, :gpo => true},
      :sidorov => {:id => 555, :last_name => "Сидоров", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "404", :year => "5", :chair_abbr => "АСУ", :active => true, :gpo => true}
    }.fetch(chel)
  end


  def test_render_valid_data
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/333.xml", {}, students(:ivanov).to_xml(:root => "student")
      # поиск по Петрова по contingent_id
      mock.get "/students/444.xml", {}, students(:petrov).to_xml(:root => "student")
      mock.get "/students/555.xml", {}, students(:sidorov).to_xml(:root => "student")
    end
    Chair.destroy_all
    Project.destroy_all
    Participant.destroy_all
    chair = Factory(:chair, :chief => "Ехлаков Ю.П.")
    project = Factory(:project, :cipher => "АОИ-0701", :title => "Пирожковый автомат", :chair => chair)
    project.state = 'active'
    project.save(false)

    participant1 = Factory(:participant, :project => project, :student => Student.find(333))
    participant1.state = 'approved'
    participant1.save(false)
    participant2 = Factory(:participant, :project => project, :student => Student.find(444))
    participant2.state = 'approved'
    participant2.save(false)
    participant3 = Factory(:participant, :project => project, :student => Student.find(555))
    participant3.state = 'approved'
    participant3.save(false)


    report = UniversityParticipants.new


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert_equal 3, oo.sheets.size, "неверное количество листов"
      assert oo.cell(1, 'A', oo.sheets[0]).include?(Date.today.to_s), "сегодня в списке 3-го"
      assert_equal "1", oo.cell(3, 'A', oo.sheets[0]), "№ пп 3"
      assert_equal "Иванов Иван Иванович", oo.cell(3, 'B', oo.sheets[0]), "ФИО 3"
      assert_equal "405", oo.cell(3, 'C', oo.sheets[0]), "№ группы 3"
      assert_equal "АОИ-0701", oo.cell(3, 'D', oo.sheets[0]), "Проект ГПО 3"

      assert oo.cell(1, 'A', oo.sheets[1]).include?(Date.today.to_s), "сегодня в списке 4-го"
      assert_equal "1", oo.cell(3, 'A', oo.sheets[1]), "№ пп 4"
      assert_equal "Петров Иван Иванович", oo.cell(3, 'B', oo.sheets[1]), "ФИО 4"
      assert_equal "406", oo.cell(3, 'C', oo.sheets[1]), "№ группы 4"
      assert_equal "АОИ-0701", oo.cell(3, 'D', oo.sheets[1]), "Проект ГПО 4"

      assert oo.cell(1, 'A', oo.sheets[2]).include?(Date.today.to_s), "сегодня в списке 5-го"
      assert_equal "1", oo.cell(3, 'A', oo.sheets[2]), "№ пп 5"
      assert_equal "Сидоров Иван Иванович", oo.cell(3, 'B', oo.sheets[2]), "ФИО 5"
      assert_equal "404", oo.cell(3, 'C', oo.sheets[2]), "№ группы 5"
      assert_equal "АОИ-0701", oo.cell(3, 'D', oo.sheets[2]), "Проект ГПО 5"
    end
  end
end
