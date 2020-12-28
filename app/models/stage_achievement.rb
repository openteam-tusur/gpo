class StageAchievement < ActiveRecord::Base
  attr_accessible :kind,
                  :title,
                  :stage_id,
                  :scan

  attr_accessor :anchor_id

  belongs_to :stage

  validates_presence_of :stage_id, :title, :kind
  has_attached_file :scan, {
    path: 'system/:class/:attachment/:date/:id/:filename',
    url: '/system/:class/:attachment/:date/:id/:filename'
  }
end

# == Schema Information
#
# Table name: stage_achievements
#
#  id                :integer          not null, primary key
#  kind              :string(255)
#  title             :text
#  scan_file_name    :string(255)
#  scan_content_type :string(255)
#  scan_file_size    :integer
#  scan_updated_at   :datetime
#  scan_url          :text
#  stage_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#
