require 'spec_helper'

describe OpeningOrder do
  describe 'state machine' do
    let(:project) { Fabricate :project }
    let(:opening_order) { Fabricate :opening_order, chair: project.chair, project_ids: [project.id] }

    describe 'event :to_review (:draft => :being_reviewed)' do
      before { opening_order.to_review! }

      it { project.reload.should be_draft }
      it { project.reload.should be_blocked }
      it { opening_order.activities.first.action.should == 'to_review'  }
    end

    describe 'event :cancel (:being_reviewed, :reviewed => :draft)' do
      before { opening_order.to_review! }
      before { opening_order.cancel! }

      it { project.reload.should be_editable }
      it { opening_order.activities.first.action.should == 'cancel'  }
    end

    describe 'event :approve (:reviewed => :approved)' do
      before { opening_order.to_review! }
      before { opening_order.review! }

      context 'without number or approved_at' do
        before { opening_order.approve }

        it { project.reload.should be_draft }
        it { opening_order.should be_reviewed }
        it { opening_order.errors.should_not be_empty }
        it { opening_order.activities.first.action.should == 'review'  }
      end

      context 'with number and approved_at' do
        before { opening_order.number = '123-123' }
        before { opening_order.approved_at = DateTime.now }
        before { opening_order.approve! }

        it { project.reload.should be_active }
        it { project.reload.should be_editable }
        it { opening_order.activities.first.action.should == 'approve'  }
      end
    end
  end
end
