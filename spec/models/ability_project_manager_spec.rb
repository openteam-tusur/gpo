# encoding: utf-8

require 'spec_helper'

describe Ability do
  context 'project_manager' do
    let(:chair) { Fabricate(:chair) }
    let(:another_chair) { Fabricate(:chair) }
    let(:project) { Fabricate(:project, chair: chair) }
    let(:another_project) { Fabricate(:project, chair: chair) }
    let(:stage) { Fabricate(:stage, project: project) }
    let(:participant) { Fabricate(:participant, project: project) }

    subject { ability_for(project_manager_of(project)) }

    context 'chairs' do
      it { should     be_able_to :read, project.chair }
      it { should_not be_able_to :manage_projects, project.chair }

      it { should_not be_able_to :read, another_chair }
    end

    context 'projects' do
      it { should     be_able_to :read, project }
      it { should     be_able_to :update, project }
      it { should_not be_able_to :to_close, project }
      it { should_not be_able_to :close, project }
      it { should_not be_able_to :create, project }
      it { should_not be_able_to :destroy, project }

      it { should_not be_able_to :read, another_project }
    end

    context 'stages' do
      it { should     be_able_to :manage, stage }
    end

    context 'participants' do
      it { should     be_able_to :create, participant }
      it { should     be_able_to :remove, participant }
      it { should     be_able_to :cancel, participant }
      it { should_not be_able_to :approve, participant }
    end
  end
end
