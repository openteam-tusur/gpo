# encoding: utf-8

require 'spec_helper'
require File.expand_path '../ability_shared_examples', __FILE__

describe Ability do
  context 'project_manager' do
    subject { ability_for(project_manager_of(project)) }

    let(:chair) { Fabricate(:chair) }
    let(:project) { Fabricate(:project, chair: chair) }

    it_should_behave_like 'project manager'

    context 'chairs' do
      it { should_not be_able_to :manage_projects, chair }
      it { should_not be_able_to :manage, chair }
    end

    context 'projects' do
      it { should_not be_able_to :to_close, project }
      it { should_not be_able_to :close, project }
      it { should_not be_able_to :create, project }
      it { should_not be_able_to :destroy, project }
    end

    context 'project_managers' do
      it { should_not be_able_to :create, project.project_managers.new }
      it { should_not be_able_to :remove, project.project_managers.new }
      it { should_not be_able_to :cancel, project.project_managers.new }
      it { should_not be_able_to :approve, project.project_managers.new }
    end
  end
end
