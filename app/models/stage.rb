class Stage < ActiveRecord::Base
  attr_accessor :skip_validation

  attr_accessible :title,
                  :start,
                  :finish,
                  :funds_required,
                  :activity,
                  :results,
                  :reporting_stage,
                  :reporting_stage_id,
                  :file_report,
                  :file_review,
                  :skip_validation,
                  :reporting_marks_attributes

  belongs_to :project
  belongs_to :reporting_stage

  has_many :reporting_marks, dependent: :destroy
  accepts_nested_attributes_for :reporting_marks

  validates_presence_of :title, :start, :finish

  has_attached_file :file_report, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }
  validates_attachment :file_report, presence: true,
    if: -> { !self.skip_validation && self.reporting_stage_id.present? }

  has_attached_file :file_review, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }
  validates_attachment :file_review, presence: true,
    if: -> { !self.skip_validation && self.reporting_stage_id.present? }

  before_post_process :normalize_file_names

  scope :for_reporting, -> { where.not(reporting_stage_id: [nil, '']) }
  scope :without_reporting_stage, -> {
    for_reporting.select{ |stage| stage.reporting_stage.blank? }
  }

  def for_reporting?
    self.reporting_stage_id.present?
  end

  def can_change?
    return true unless for_reporting?

    Time.zone.now.between?(start, finish + 1.day)
  end

  protected

  def self.allowed?(user, project)
    user.is_a?(User) && project.updatable_by?(user)
  end

  private

  def normalize_file_names
    %W(file_report_file_name file_review_file_name).each do |item|

      filename = send(item)
      next if filename.blank?
      ext = File.extname filename
      name = File.basename filename, ext
      name = Russian.transliterate(name).downcase.parameterize.underscore.truncate(200)
      send(%(#{item}=), %(#{name}#{ext}))
    end
  end
end

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
