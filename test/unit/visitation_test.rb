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
    assert_equal 4, kt.sum
    assert_equal 4, kt.total
  end

  test "считаем сумму за второе кт и итого за все" do
    Factory.create(:visitation, :participant => @participant)
    Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    Factory.create(:visitation, :participant => @participant)
    Factory.create(:visitation, :participant => @participant)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true), :participant => @participant)
    assert_equal 3, kt.sum
    assert_equal 6, kt.total
  end

  test "два студента" do
    second_student_visitation = Factory.create(:visitation, :gpoday => @first_day)
    first_student_second_visitation = Factory.create(:visitation, :participant => @participant)
    assert_equal 2, first_student_second_visitation.sum
  end

end
