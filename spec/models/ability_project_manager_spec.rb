# encoding: utf-8

require 'spec_helper'

describe Ability do
  context 'project_manager' do
    let(:chair) { Fabricate(:chair) }
    let(:project) { Fabricate(:project, chair: chair) }
    let(:another_project) { Fabricate(:project, chair: chair) }
    let(:stage) { Fabricate(:stage, project: project) }
    let(:another_stage) { Fabricate(:stage, project: another_project) }

    subject { ability_for(project_manager_of(project)) }

    context 'projects' do
      it { should     be_able_to :update, project }
      it { should_not be_able_to :manage, project }

      it { should_not be_able_to :update, another_project }
    end

    context 'stages' do
      it { should     be_able_to :manage, stage }
      it { should_not be_able_to :manage, another_stage }
    end
  end
end
