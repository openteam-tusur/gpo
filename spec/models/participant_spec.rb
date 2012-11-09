# encoding: utf-8

require 'spec_helper'

describe Participant do
  describe '#undergraduate' do
    context ':edu_group => 425-2' do
      subject { Fabricate :participant, edu_group: '425-2', project: Fabricate(:project) }

      its(:undergraduate) { should be_false }
    end

    context ':edu_group => 425-2М' do
      subject { Fabricate :participant, edu_group: '425-2М', project: Fabricate(:project) }

      its(:undergraduate) { should be_true }
    end
  end
end
