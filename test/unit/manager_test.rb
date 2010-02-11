require File.dirname(__FILE__) + '/../test_helper'

class ManagerTest < ActiveSupport::TestCase
  should_have_db_column :user_id
  should_have_db_column :project_id
end
