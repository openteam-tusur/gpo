# encoding: utf-8
class Activity < ActiveRecord::Base
  belongs_to :chair
  belongs_to :context, :polymorphic => true

  scope :orders, where(:context_type => Order)
  scope :for_order, ->(id) { orders.where(:id => id) }
  scope :recent, limit(10).order('created_at desc')
end
