require File.dirname(__FILE__) + '/../test_helper'
class VisitationTest < ActiveSupport::TestCase

  test "два дня, узнаем предыдущую дату" do
    first = Factory.create(:visitation)
    second = Factory.create(:visitation)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true))
    assert_equal Date.parse("08.01.2010"), second.prev.date
    assert_equal Date.parse("15.01.2010"), kt.prev.date
    assert_nil first.prev
    assert_equal second, first.next
    assert_nil kt.prev_kt
  end

  test "считаем сумму за кт и итого" do
    first = Factory.create(:visitation)
    second = Factory.create(:visitation)
    third = Factory.create(:visitation)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true))
    assert_equal 4, kt.summ
    assert_equal 4, kt.total
  end

  test "считаем сумму за второе кт и итого за все" do
    Factory.create(:visitation)
    Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true))
    Factory.create(:visitation)
    Factory.create(:visitation)
    kt = Factory.create(:visitation, :gpoday => Factory.create(:gpoday, :kt => true))
    assert_equal 3, kt.summ
    assert_equal 5, kt.total
  end

end
