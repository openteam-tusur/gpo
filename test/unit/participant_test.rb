require File.dirname(__FILE__) + '/../test_helper'

class ParticipantTest < ActiveSupport::TestCase
  should_have_db_column :student_id
  should_have_db_column :state
end
