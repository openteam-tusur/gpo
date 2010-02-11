require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"
require "roo"

class ParticipantIssuesTest < Test::Unit::TestCase
  def students(chel)
    {:ivanov => {:id => 111, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "4", :chair_abbr => "АОИ", :active => true, :gpo => true}
    }.fetch(chel)
  end

  def test_render_valid_data
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/111.xml", {}, students(:ivanov).to_xml(:root => "student")
    end
    chair = Factory(:chair, :chief => "Ехлаков Ю.П.")
    project = Factory(:project, :cipher => "АОИ-0701", :title => "Пирожковый автомат", :chair => chair)
    project.state = 'active'
    project.save(false)
    participant = Factory(:participant, :project => project, :student => Student.find(111))
    participant.state = 'approved'
    participant.save(false)
    issue1 = participant.issues.create!(:name => "Задача 1", :description => "Описание 1", :planned_closing_at => "2010-02-11", :closed_at => "2010-02-21", :planned_grade => 3, :grade => 2, :results => "Описание результата")
    issue2 = participant.issues.create!(:name => "Задача 2", :description => "Описание 2", :planned_closing_at => "2010-03-11", :planned_grade => 4)

    report = ParticipantIssues.new(participant)

    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(2, 'A').include?(report.semestr), "тип семестра"
      assert oo.cell(2, 'A').include?(report.edu_years), "годы семестра"
      assert oo.cell(3, 'A').include?(project.cipher), "шифр проекта"
      assert oo.cell(3, 'A').include?(project.title), "название проекта"
      assert oo.cell(4, 'A').include?(participant.name), "ФИО участника"
      assert oo.cell(4, 'A').include?(participant.edu_group), "учебная группа участника"

      assert oo.cell(6, 'A').include?("1"), "№ задачи"
      assert oo.cell(6, 'B').include?(issue1.name), "название задачи"
      assert oo.cell(6, 'C').include?(issue1.description), "содержание работ"
      assert_equal issue1.planned_closing_at, oo.cell(6, 'D'), "плановая дата выполнения"
      assert_equal issue1.closed_at, oo.cell(6, 'E'), "фактическая дата выполнения"
      assert_equal issue1.planned_grade.to_f, oo.cell(6, 'F'), "плановое кол-во баллов"
      assert_equal issue1.grade.to_f, oo.cell(6, 'G'), "фактическое кол-во баллов"
      assert oo.cell(6, 'H').include?(issue1.results), "описание результата"

      assert oo.cell(7, 'A').include?("2"), "№ задачи"
      assert oo.cell(7, 'B').include?(issue2.name), "название задачи"
      assert oo.cell(7, 'C').include?(issue2.description), "содержание работ"
      assert_equal issue2.planned_closing_at, oo.cell(7, 'D'), "плановая дата выполнения"
      assert_equal "", oo.cell(7, 'E'), "фактическая дата выполнения"
      assert_equal issue2.planned_grade.to_f, oo.cell(7, 'F'), "плановое кол-во баллов"
      assert_equal "", oo.cell(7, 'G'), "фактическое кол-во баллов"
      assert_equal "", oo.cell(7, 'H'), "описание результата"

      assert_equal 7.to_f, oo.cell(8, 'F'), "сумма плановых баллов"
      assert_equal 2.to_f, oo.cell(8, 'G'), "сумма фактических баллов"
    end
  end
end
