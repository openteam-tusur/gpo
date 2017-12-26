class ReportingStage < ActiveRecord::Base
  attr_accessible  :title, :start, :finish
  validates_presence_of :title, :start, :finish

  scope :ascending,  -> { order('start asc') }
  scope :descending, -> { order('start desc') }

  default_value_for :title do
    result = 'Этап аттестации за '
    if Date.today > Date.parse(%(#{Date.today.year}-06-30))
      result += ''
      result += %(осенний семестр #{Date.today.year}/#{Date.today.year + 1})
    else
      result += %(весенний семестр #{Date.today.year - 1}/#{Date.today.year})
    end
    result += ' учебный год'

    result
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
