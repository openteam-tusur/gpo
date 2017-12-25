# encoding: utf-8
# == Schema Information
#
# Table name: participants
#
#  id                :integer          not null, primary key
#  student_id        :integer
#  state             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :integer
#  course            :integer
#  first_name        :string(255)
#  middle_name       :string(255)
#  last_name         :string(255)
#  edu_group         :string(255)
#  contingent_active :boolean
#  contingent_gpo    :boolean
#  undergraduate     :boolean
#  subfaculty        :string(255)
#  faculty           :string(255)
#  executive         :boolean          default(FALSE)
#  type              :string(255)
#  university        :string(255)
#

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
