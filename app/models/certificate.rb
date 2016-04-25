class Certificate < ActiveRecord::Base
  attr_accessible :participant_id, :project_result, :project_reason, :user_id, :state

  belongs_to :participant

  scope :for_mentor, -> { where(state: ['send_to_mentor', 'published']) }
  scope :for_manager, -> { where(state: ['send_to_manager', 'published']) }
  scope :pdf, -> { where(state: 'published') }

  state_machine :state, initial: :initialized do
    event :approve do
      transition initialized: :send_to_mentor,
                 send_to_mentor: :send_to_manager,
                 send_to_manager: :published
    end

    event :decline do
      transition published: :send_to_manager,
                 send_to_manager: :send_to_mentor,
                 send_to_mentor: :initialized
    end
  end

  def user
    User.find_by(id: user_id)
  end

  def state_text
    I18n.t "activerecord.state_machines.certificate.state.#{state}"
  end
end
