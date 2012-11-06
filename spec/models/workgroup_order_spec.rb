# == Schema Information
#
# Table name: ordinances
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  approved_at       :date
#  chair_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  type              :string(255)
#  state             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :date
#

require 'spec_helper'

describe WorkgroupOrder do
  describe 'state machine' do
    before { Participant.any_instance.stub(:update_from_contingent) }

    let(:project) { Fabricate :project }
    let(:workgroup_order) { Fabricate :workgroup_order, chair: project.chair, project_ids: [project.id] }

    describe 'event :approve (:reviewed => :approved)' do
      before { workgroup_order.to_review! }
      before { workgroup_order.review! }

      before { workgroup_order.number = '123-123' }
      before { workgroup_order.approved_at = DateTime.now }
      before { workgroup_order.approve! }

      it { project.reload.should be_active }
      it { project.reload.should be_editable }
    end
  end
end
