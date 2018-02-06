class ReportingMark < ActiveRecord::Base
  attr_accessor :skip_validation

  belongs_to :stage

  attr_accessible :fullname,
                  :group,
                  :course,
                  :faculty,
                  :subfaculty,
                  :contingent_id,
                  :mark,
                  :stage_id,
                  :skip_validation

  validates :mark, presence: true,
    if: -> { !self.skip_validation }

  extend Enumerize

  enumerize :mark, in: %W[5 4 3 2 н/а]

end

# == Schema Information
#
# Table name: reporting_marks
#
#  id            :integer          not null, primary key
#  fullname      :string(255)
#  group         :string(255)
#  course        :integer
#  faculty       :string(255)
#  subfaculty    :string(255)
#  contingent_id :integer
#  mark          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  stage_id      :integer
#
