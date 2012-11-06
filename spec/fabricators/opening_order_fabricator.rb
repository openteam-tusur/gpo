# == Schema Information
#
# Table name: ordinances
#
#  id          :integer          not null, primary key
#  number      :string(255)
#  approved_at :date
#  chair_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  type        :string(255)
#  state       :string(255)
#  vfs_path    :string(255)
#

Fabricator(:opening_order) do
  chair
end
