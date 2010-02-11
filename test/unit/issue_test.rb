require File.dirname(__FILE__) + '/../test_helper'
require "active_resource"
require "active_resource/http_mock"

class IssueTest < ActiveSupport::TestCase
  should_validate_presence_of :participant_id, :name, :planned_closing_at, :planned_grade
  should_belong_to :participant

  def students(chel)
    {:ivanov => {:id => 333, :last_name => "Иванов", :first_name => "Иван", :mid_name => "Иванович", :edu_group => "405", :year => "3", :chair_abbr => "АОИ", :active => true, :gpo => true}
    }.fetch(chel)
  end

  test "должно требоваться заполнение баллов и результатов, если указана дата завершения" do
    ActiveResource::HttpMock.respond_to do |mock|
      mock.get "/students/333.xml", {}, students(:ivanov).to_xml(:root => "student")
    end
    participant = Factory.create(:participant, :student => Student.find(333))
    issue = Factory.build(:issue, :participant => participant)
    issue.save
    assert issue.errors.on(:closed_at).nil?
    assert issue.errors.on(:grade).nil?
    assert issue.errors.on(:results).nil?

    issue.closed_at = Date.today
    issue.save
    assert issue.errors.on(:closed_at).nil?
    assert_equal "не может быть пустым", issue.errors.on(:grade)
    assert_equal "не может быть пустым", issue.errors.on(:results)
    issue.closed_at = nil

    issue.grade = 3
    issue.save
    assert issue.errors.on(:grade).nil?
    assert_equal "не может быть пустым", issue.errors.on(:closed_at)
    assert_equal "не может быть пустым", issue.errors.on(:results)

    issue.closed_at = Date.today
    issue.grade = 3
    issue.save
    assert issue.errors.on(:grade).nil?
    assert issue.errors.on(:closed_at).nil?
    assert_equal "не может быть пустым", issue.errors.on(:results)

    issue.closed_at = Date.today
    issue.grade = 3
    issue.results = "результ"
    issue.save
    assert issue.errors.on(:grade).nil?
    assert issue.errors.on(:closed_at).nil?
    assert issue.errors.on(:results).nil?
  end

end
