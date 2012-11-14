# encoding: utf-8

require 'spec_helper'
require File.expand_path '../ability_shared_examples', __FILE__

describe Ability do
  context 'mentor' do
    subject { ability_for(mentor_of(chair)) }

    let(:chair) { Fabricate(:chair) }
    let(:project) { Fabricate(:project, chair: chair) }

    it_should_behave_like 'project manager'

    context 'chairs' do
      it { should     be_able_to :manage_projects,  chair }
      it { should_not be_able_to :manage,           chair }
    end

    context 'projects' do
      it { should     be_able_to :to_close,  project }
      it { should     be_able_to :close,     project }
      it { should     be_able_to :create,    project }
      context '#destroy' do
        it { should     be_able_to :destroy,   project }
        it { should_not be_able_to :destroy,   project.tap {|p| p.stub(:draft?)} }
      end
    end

    context 'project_managers' do
      it { should     be_able_to :create,   project.project_managers.new }
      it { should     be_able_to :remove,   project.project_managers.new }
      it { should     be_able_to :cancel,   project.project_managers.new }
      it { should_not be_able_to :approve,  project.project_managers.new }
    end

    context 'orders' do
      it { should     be_able_to :create,     chair.opening_orders.new }
      it { should     be_able_to :to_review,  chair.opening_orders.new }
      it { should_not be_able_to :cancel,     chair.opening_orders.new }
      it { should_not be_able_to :review,     chair.opening_orders.new }
      it { should_not be_able_to :approve,    chair.opening_orders.new }

      def order(state)
        chair.opening_orders.new.tap do |order|
          order.stub(:state => state)
          order.stub(:draft? => false)
          order.stub("#{state}?" => true)
        end
      end

      context '#update' do
        it { should     be_able_to :update,   order(:draft) }
        it { should_not be_able_to :update,   order(:being_reviewed) }
        it { should_not be_able_to :update,   order(:reviewed) }
        it { should_not be_able_to :update,   order(:approved) }
      end

      context '#destroy' do
        it { should     be_able_to :destroy,  order(:draft) }
        it { should_not be_able_to :destroy,  order(:being_reviewed) }
        it { should_not be_able_to :destroy,  order(:reviewed) }
        it { should_not be_able_to :destroy,  order(:approved) }
      end
    end
  end
end
