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
#  faculty    :string(255)
#

Fabricator(:chair)  do
  abbr  {"ABBR#{Fabricate.sequence(:abbr)}"}
  chief 'chief'
  title 'title'
end
