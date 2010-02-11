class Activity < ActiveRecord::Base
  belongs_to :chair
  belongs_to :context, :polymorphic => true
  
  named_scope :orders, :conditions => { :context_type => Order.name}
  named_scope :for_order, lambda { |id| { :conditions => { :context_type => Order.name, :context_id => id } } }
  named_scope :recent, :limit => 10, :order => 'created_at desc'
end
