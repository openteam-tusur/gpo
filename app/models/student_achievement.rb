class StudentAchievement < ActiveRecord::Base
  attr_accessible :title,
                  :kind,
                  :stage_id,
                  :scan

  attr_accessor :anchor_id

  has_many :participant_student_achievements
  has_many :participants, through: :participant_student_achievements, dependent: :destroy
  belongs_to :stage

  validates_presence_of :stage_id, :title, :kind

  validate :has_participants

  scope :diplomas, -> { where(kind: 'diploma') }
  scope :publications, -> { where(kind: 'publication') }
  scope :international_reports, -> { where(kind: 'international_report') }

  has_attached_file :scan, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }

  def has_participants
    unless participants.size > 0
      errors.add(:participants, "Не указаны участники")
    end
  end
end

# == Schema Information
#
# Table name: student_achievements
#
#  id                :integer          not null, primary key
#  kind              :string(255)
#  title             :text
#  scan_file_name    :string(255)
#  scan_content_type :string(255)
#  scan_file_size    :integer
#  scan_updated_at   :datetime
#  scan_url          :text
#  participant_id    :integer
#  stage_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#
