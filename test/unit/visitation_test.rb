require File.dirname(__FILE__) + '/../test_helper'
class VisitationTest < ActiveSupport::TestCase

  def setup
    @first_visitation = Factory.create(:visitation)
    @first_day = @first_visitation.gpoday
    @participant = @first_visitation.participant
  end

  test "считаем сумму за кт и итого" do
    second = Factory.create(:visitation, :participant => @participant)
    third = Factory.create(:visitation, :participant => @participant)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    assert_equal 4, kt.kt_sum
    assert_equal 4, kt.total_sum
  end

  test "считаем сумму за второе кт и итого за все" do
    Factory.create(:visitation, :participant => @participant)
    Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    Factory.create(:visitation, :participant => @participant)
    Factory.create(:visitation, :participant => @participant)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    assert_equal 3, kt.kt_sum
    assert_equal 6, kt.total_sum
  end

  test "два студента" do
    second_student_visitation = Factory.create(:visitation, :gpoday => @first_day)
    first_student_second_visitation = Factory.create(:visitation, :participant => @participant)
    assert_equal 2, first_student_second_visitation.kt_sum
  end

  test "и есть выполненное индивидуальное задание" do
    second = Factory.create(:visitation, :participant => @participant)
    Factory.create(:issue, :participant => @participant, :closed_at => second.gpoday.date)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    assert_equal 1, kt.kt_issues_sum
    assert_equal 4, kt.kt_sum
    assert_equal 4, kt.total_sum
  end

  test "и есть два выполненных индивидуальных задач" do
    Factory.create(:visitation, :participant => @participant)
    Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    first = Factory.create(:visitation, :participant => @participant)
    Factory.create(:issue, :participant => @participant, :closed_at => first.gpoday.date)
    Factory.create(:issue, :participant => @participant, :closed_at => first.gpoday.date)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    assert_equal 2, kt.kt_issues_sum
    assert_equal 4, kt.kt_sum
    assert_equal 7, kt.total_sum
  end

end
