# encoding: utf-8
class OrderProject < ActiveRecord::Base
  belongs_to :order
  belongs_to :project
end
