# == Schema Information
#
# Table name: stages
#
#  id                       :integer          not null, primary key
#  project_id               :integer
#  title                    :text
#  start                    :date
#  finish                   :date
#  funds_required           :text
#  activity                 :text
#  results                  :text
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  reporting_stage_id       :integer
#  file_report_file_name    :string(255)
#  file_report_content_type :string(255)
#  file_report_file_size    :integer
#  file_report_updated_at   :datetime
#  file_report_url          :text
#  file_review_file_name    :string(255)
#  file_review_content_type :string(255)
#  file_review_file_size    :integer
#  file_review_updated_at   :datetime
#  file_review_url          :text
#

Fabricator(:stage) do
  project
  title "title"
  start "01.01.2012"
  finish "01.02.2012"
end
