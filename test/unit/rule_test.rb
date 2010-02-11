require File.dirname(__FILE__) + '/../test_helper'

class RuleTest < ActiveSupport::TestCase
  should_have_db_column :user_id
  should_have_db_column :role
  should_have_db_column :context_type
  should_have_db_column :context_id
  
  should_belong_to :user  
end
