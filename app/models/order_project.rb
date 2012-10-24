# encoding: utf-8

# == Schema Information
#
# Table name: order_projects
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  project_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class OrderProject < ActiveRecord::Base
  belongs_to :order
  belongs_to :project
end
