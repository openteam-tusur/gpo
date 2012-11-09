# encoding: utf-8

require 'spec_helper'

describe Ability do
  context 'менеджер проекта' do
    let(:project) { Fabricate(:project) }
    subject { ability_for(project_manager_of(project)) }

    it { should_not be_able_to(:manage, another_manager_of(project).permissions.first) }
  end
end
