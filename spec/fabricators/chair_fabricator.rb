# == Schema Information
#
# Table name: chairs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  chief      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

Fabricator(:chair)  do
  abbr 'ABBR'
  chief 'Chair chief'
  title 'Chair title'
end
