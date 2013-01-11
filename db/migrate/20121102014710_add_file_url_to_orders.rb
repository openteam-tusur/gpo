# encoding: utf-8

class AddFileUrlToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :file_url, :text
  end
end
