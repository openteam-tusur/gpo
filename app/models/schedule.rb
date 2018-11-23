class Schedule < ActiveRecord::Base
  extend Enumerize

  enumerize :schedule_type, in: [:group, :project_managers]

  attr_accessible :chair_id, :schedule_type

  belongs_to :chair
end
