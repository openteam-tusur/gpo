class InternationalReport < ActiveRecord::Base
  belongs_to :participant
  belongs_to :stage
end
