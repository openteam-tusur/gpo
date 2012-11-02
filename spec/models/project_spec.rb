require 'spec_helper'

describe Project do
  describe 'state machine' do
    before { Participant.any_instance.stub(:update_from_contingent) }

    describe 'event :approve (:draft => :active)' do
      subject { Fabricate :project }

      before { subject.approve! }

      it { subject.managers.first.should be_approved }
      it { subject.participants.first.should be_approved }
    end
  end
end
