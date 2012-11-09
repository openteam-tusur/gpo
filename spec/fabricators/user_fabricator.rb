# == Schema Information
#
# Table name: users
#
#  id                        :integer          not null, primary key
#  login                     :string(40)
#  email                     :string(100)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  created_at                :datetime
#  updated_at                :datetime
#  remember_token            :string(40)
#  remember_token_expires_at :datetime
#  mid_name                  :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  post                      :string(255)
#  chair_id                  :integer
#  float                     :string(255)
#  phone                     :string(255)
#

Fabricator(:user) do
  uid { Fabricate.sequence :uid }
  email { Forgery(:internet).email_address }
  first_name 'First name'
  mid_name 'Middle name'
  last_name 'Last name'
end
