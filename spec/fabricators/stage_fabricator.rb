# == Schema Information
#
# Table name: stages
#
#  id             :integer          not null, primary key
#  project_id     :integer
#  title          :text
#  start          :date
#  finish         :date
#  funds_required :text
#  activity       :text
#  results        :text
#  created_at     :datetime
#  updated_at     :datetime
#

Fabricator(:stage) do
  project
  title "title"
  start "01.01.2012"
  finish "01.02.2012"
end
