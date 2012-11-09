# encoding: utf-8

require 'spec_helper'

describe Ability do
  context 'mentor' do
    let(:chair) { Fabricate(:chair) }
    let(:project) { Fabricate(:project, chair: chair) }
    let(:another_project) { Fabricate(:project) }
    let(:stage) { Fabricate(:stage, project: project) }
    let(:another_stage) { Fabricate(:stage) }

    subject { ability_for(mentor_of(chair)) }

    context 'projects' do
      it { should be_able_to :manage, project }
      it { should_not be_able_to :manage, another_project }
    end

    context 'stages' do
      it { should be_able_to :manage, stage }
      it { should_not be_able_to :manage, another_stage }
    end
  end
end
