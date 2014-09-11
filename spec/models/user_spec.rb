# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(100)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  middle_name        :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  post               :string(255)
#  chair_id           :integer
#  float              :string(255)
#  phone              :string(255)
#  uid                :string(255)
#  sign_in_count      :integer
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#

require 'spec_helper'

describe User do

  it { should normalize_attribute(:email) }
  it { should normalize_attribute(:first_name) }
  it { should normalize_attribute(:middle_name) }
  it { should normalize_attribute(:last_name) }
  it { should normalize_attribute(:post) }
  it { should normalize_attribute(:float) }
  it { should normalize_attribute(:phone) }

  context 'with uid' do
    subject { User.new do |u| u.uid = '1' end }
    its(:from_sso?) { should be_true }
    it { should_not validate_presence_of :first_name }
    it { should_not validate_presence_of :middle_name }
    it { should_not validate_presence_of :last_name }
  end

  context 'without uid' do
    its(:from_sso?) { should be_false }
    it { should     validate_presence_of :first_name }
    it { should     validate_presence_of :middle_name }
    it { should     validate_presence_of :last_name }
  end
end
