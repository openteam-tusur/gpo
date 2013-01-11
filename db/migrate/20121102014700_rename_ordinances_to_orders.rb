# encoding: utf-8

class RenameOrdinancesToOrders < ActiveRecord::Migration
  def change
    rename_table :ordinances, :orders
  end
end
