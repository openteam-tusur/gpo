class Person < ActiveRecord::Base
  belongs_to :chair

  def user
    User.find_by(:id => user_id)
  end
end
