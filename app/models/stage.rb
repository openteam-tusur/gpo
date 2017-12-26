class Stage < ActiveRecord::Base
  attr_accessible  :title, :start, :finish, :funds_required,
    :activity, :results, :reporting_stage, :reporting_stage_id

  scope :for_reporting, -> { where.not(reporting_stage_id: [nil, '']) }
  scope :without_reporting_stage, -> {
    for_reporting.select{ |stage| stage.reporting_stage.blank? }
  }

  belongs_to :project
  belongs_to :reporting_stage

  validates_presence_of :title, :start, :finish

  def for_reporting?
    reporting_stage_id.present?
  end

  protected

  def self.allowed?(user, project)
    user.is_a?(User) && project.updatable_by?(user)
  end
end

# == Schema Information
#
# Table name: stages
#
#  id                 :integer          not null, primary key
#  project_id         :integer
#  title              :text
#  start              :date
#  finish             :date
#  funds_required     :text
#  activity           :text
#  results            :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  reporting_stage_id :integer
#
