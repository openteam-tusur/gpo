require File.dirname(__FILE__) + '/../test_helper'

class ProjectTest < ActiveSupport::TestCase
  should_have_db_column :cipher
  should_have_db_column :title
  
  should_belong_to :chair  
end
