# encoding: utf-8

# == Schema Information
#
# Table name: stages
#
#  id             :integer          not null, primary key
#  project_id     :integer
#  title          :text
#  start          :date
#  finish         :date
#  funds_required :text
#  activity       :text
#  results        :text
#  created_at     :datetime
#  updated_at     :datetime
#

class Stage < ActiveRecord::Base
  attr_accessible  :title, :start, :finish, :funds_required, :activity, :results
  belongs_to :project

  validates_presence_of :title, :start, :finish

  protected

  def self.allowed?(user, project)
    user.is_a?(User) && project.updatable_by?(user)
  end
end
