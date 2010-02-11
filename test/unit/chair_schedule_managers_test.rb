require File.dirname(__FILE__) + '/../test_helper'
require "roo"

class ChairScheduleManagersTest < Test::Unit::TestCase

  def test_render_valid_data
    chair = Factory(:chair, :chief => "Ехлаков Ю.П.")
    project = Factory(:project, :cipher => "АОИ-0701", :title => "Пирожковый автомат", :chair => chair)
    project.state = 'active'
    project.save(false)
    project1 = Factory(:project, :cipher => "АОИ-0703", :title => "Пирожковый автомат", :chair => chair)
    project1.state = 'active'
    project1.save(false)
    user1 = Factory(:user, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :post => "завзавзав, к.т.н")
    manager = Factory(:manager, :project => project, :user => user1)
    manager.state = 'approved'
    manager.save(false)
    manager = Factory(:manager, :project => project1, :user => user1)
    manager.state = 'approved'
    manager.save(false)


    report = ChairScheduleManagers.new(chair)


    report.render_to_file do |tmp_file|
      oo = Openoffice.new(tmp_file.path)
      assert oo.cell(2, 'D').include?(chair.abbr), "аббревиатура каф"
      assert oo.cell(3, 'D').include?(chair.chief), "зав каф"
      assert oo.cell(4, 'D').include?(Date.today.year.to_s), "текущий год"
      assert oo.cell(5, 'A').include?(report.semestr), "тип семестра"
      assert oo.cell(5, 'A').include?(report.edu_years), "учебный год"
      index = 7
      chair.managers.each do |manager|
        assert_equal manager.name,  oo.cell(index, 'A'), "ФИО"
        assert_equal manager.post,  oo.cell(index, 'B'), "Должность, уч. звание"
        manager.managable_projects.each do |project|
          assert_equal project.cipher,  oo.cell(index, 'C'), "проект"
          index += 1
        end
      end
    end
  end
end
