# == Schema Information
#
# Table name: project_managers
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#  state      :string(255)
#

Fabricator(:project_manager) do
  user
end
