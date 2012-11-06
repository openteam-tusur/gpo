# encoding: utf-8

class RemovePaperclipFromOrders < ActiveRecord::Migration
  def odt_file(order)
    "#{Rails.root}/public/files/order_#{order.id}.odt"
  end

  def up
    add_column :ordinances, :vfs_path, :string
    if Dir["#{Rails.root}/public/files"].any?
      require 'progress_bar'
      puts "Миграция приказов"
      bar = ProgressBar.new(Order.approved.count)
      Order.approved.find_each do |order|
        if File.exist?(odt_file(order))
          order.upload_file(odt_file(order))
        else
          puts "нет файла приказа #{order.id}"
        end
        bar.increment!
      end
    end
    remove_column :ordinances, :file_file_name
    remove_column :ordinances, :file_content_type
    remove_column :ordinances, :file_file_size
    remove_column :ordinances, :file_updated_at
  end

  def down
    remove_column :ordinances, :vfs_path
    add_column :ordinances, :file_file_name,    :string
    add_column :ordinances, :file_content_type, :string
    add_column :ordinances, :file_file_size,    :integer
    add_column :ordinances, :file_updated_at,   :date
  end
end
