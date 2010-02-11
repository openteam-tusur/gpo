require File.dirname(__FILE__) + '/../test_helper'

class ChairTest < ActiveSupport::TestCase

  setup do
    @chair = Chair.create(:title => 'АОИ', :abbr => "АОИ", :chief => "Ехлаков")
  end

  should_have_db_columns :id, :title, :abbr, :chief, :created_at, :updated_at
  should_validate_uniqueness_of :abbr

  should_have_many :projects

  should_have_instance_methods :id_to_s, :managers, :build_order
end
