class ReportingStage < ActiveRecord::Base
  attr_accessible  :title, :start, :finish
  validates_presence_of :title, :start, :finish

  has_many :stages

  scope :ascending,  -> { order('start asc') }
  scope :descending, -> { order('start desc') }

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

  private

  def associate_stages
    if stages.any?
      stages.each do |stage|
        stage.update_attributes(
          title: self.title,
          start: self.start,
          finish: self.finish,
          reporting_stage: self
        )
      end
    else
      Project.active.each do |project|
        project.stages.create(
          title: self.title,
          start: self.start,
          finish: self.finish,
          reporting_stage: self
        )
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
