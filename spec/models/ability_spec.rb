# encoding: utf-8

require 'spec_helper'

describe Ability do
  context 'менеджер' do
    subject { ability_for(manager_of(root)) }

    it { should be_able_to(:manage, :all) }
  end
end
