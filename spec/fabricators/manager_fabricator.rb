# == Schema Information
#
# Table name: managers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

Fabricator(:manager) do
  user
end
