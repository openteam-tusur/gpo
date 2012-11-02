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
