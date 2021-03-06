class ReportingStage < ActiveRecord::Base
  attr_accessible  :title, :start, :finish
  validates_presence_of :title, :start, :finish

  has_many :stages, dependent: :destroy

  scope :ascending,  -> { order('start asc') }
  scope :descending, -> { order('start desc') }

  before_create :save_snapshot
  after_save :associate_stages

  default_value_for :title do
    result = 'Промежуточная аттестация за '
    if Date.today > Date.parse(%(#{Date.today.year}-06-30))
      result += ''
      result += %(осенний семестр #{Date.today.year}/#{Date.today.year + 1})
    else
      result += %(весенний семестр #{Date.today.year - 1}/#{Date.today.year})
    end
    result += ' учебный год'

    result
  end

  def filled?
    stages.each do |stage|
      if !stage.reporting_filled?
        return false
        break
      end
    end
  end

  def kind_of_semester
    title.match(/осенний|весенний/i).to_s
  end

  def declension_kind_of_semester
    kind_of_semester.gsub(/\D{2}$/, 'ем')
  end

  def year_of_title
    title.match(/\d{4}\/\d{4}/i).to_s
  end

  private

  def save_snapshot
    StatisticsSnapshot.build_and_save
  end

  def associate_stages
    if stages.any?
      stages.each do |stage|
        stage.update_attributes!(
          title: self.title,
          start: self.start,
          finish: self.finish,
          reporting_stage: self,
          skip_validation: true
        )
      end
    else
      Project.active.each do |project|
        stage = project.stages.create!(
          title: self.title,
          start: self.start,
          finish: self.finish,
          reporting_stage: self,
          skip_validation: true
        )
        project.participants.active.each do |participant|
          stage.reporting_marks.create(
            fullname: [
              participant.last_name,
              participant.first_name,
              participant.middle_name
            ].delete_if(&:blank?).join(' ').squish,
            group: participant.edu_group,
            course: participant.course,
            faculty: participant.faculty,
            subfaculty: participant.subfaculty,
            contingent_id: participant.student_id,
            mark: nil,
            skip_validation: true
          )
        end
      end
    end
  end

end

# == Schema Information
#
# Table name: reporting_stages
#
#  id         :integer          not null, primary key
#  title      :text
#  start      :date
#  finish     :date
#  created_at :datetime
#  updated_at :datetime
#
