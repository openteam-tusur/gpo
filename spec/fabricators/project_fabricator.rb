# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  cipher            :string(255)
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chair_id          :integer
#  stakeholders      :text
#  funds_required    :text
#  funds_sources     :text
#  purpose           :text
#  features          :text
#  analysis          :text
#  novelty           :text
#  expected_results  :text
#  release_cost      :text
#  forecast          :text
#  state             :string(255)
#  editable_state    :string(255)
#  close_reason      :text
#  theme_id          :integer
#  goal              :text
#  source_data       :text
#  sbi_placing       :string(255)
#  interdisciplinary :string(255)
#  category          :string(255)
#  result            :string(255)
#  closed_on         :date
#

Fabricator(:project) do
  chair
  cipher 'Project chiper'
  title 'Project title'

  after_create { |project| project.participants << Fabricate(:participant, project: project) }
  after_create { |project| Fabricate(:project_manager, project: project) }
end
