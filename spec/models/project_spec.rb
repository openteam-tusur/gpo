# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  cipher           :string(255)
#  title            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  chair_id         :integer
#  stakeholders     :text
#  funds_required   :text
#  funds_sources    :text
#  purpose          :text
#  features         :text
#  analysis         :text
#  novelty          :text
#  expected_results :text
#  release_cost     :text
#  forecast         :text
#  state            :string(255)
#  editable_state   :string(255)
#  close_reason     :text
#  theme_id         :integer
#  goal             :text
#  source_data      :text
#

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
