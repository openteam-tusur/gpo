# encoding: utf-8
# == Schema Information
#
# Table name: activities
#
#  id           :integer          not null, primary key
#  action       :text
#  comment      :text
#  context_type :string(255)
#  context_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chair_id     :integer
#  actor        :string(255)
#

class Activity < ActiveRecord::Base
  attr_accessible :action, :comment, :chair_id, :actor
  belongs_to :chair
  belongs_to :context, :polymorphic => true

  scope :orders,    -> { where(:context_type => Order) }
  scope :for_order, ->(id) { orders.where(:id => id) }
  scope :recent,    -> { limit(10).order('created_at desc') }
end
