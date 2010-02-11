require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  should_have_db_column :first_name
  should_have_db_column :last_name
  should_have_db_column :mid_name
  should_have_db_column :login
  should_have_db_column :crypted_password
  should_have_db_column :post

  def test_create_user_by_name
    user = User.new(:name => "Иванов Пётр Фёдорович")
    assert_equal user.first_name, "Пётр", "имя не установилось"
    assert_equal user.mid_name, "Фёдорович", "отчество не установилось"
    assert_equal user.last_name, "Иванов", "фамилия не установилось"
  end
end
