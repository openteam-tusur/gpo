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

Fabricator(:user) do
  uid { Fabricate.sequence :uid }
  email { Forgery(:internet).email_address }
  first_name 'First name'
  middle_name 'Middle name'
  last_name 'Last name'
end
