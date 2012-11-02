# encoding: utf-8

class RemovePaperclipFromOrders < ActiveRecord::Migration
  include SendReport
  BASE_URL="#{Settings['storage.url']}/api/el_finder/v2/"
  # gpo/old_orders/

  def path(order)
    "#{Rails.root}/public/files/order_#{order.id}.odt"
  end

  def upload(order)
    file_uploaded = false
    curl = Curl::Easy.new("#{BASE_URL}?cmd=upload&target=r1_Z3BvL29sZF9vcmRlcnM") do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.multipart_form_post = true
      curl.on_success { file_uploaded = true  }
    end
    docfile = File.open("/tmp/order_#{order.id}.doc", 'wb')

    report = {}
    while report[:content_type] != 'application/msword'
      report = convert_report(path(order), :doc)
    end

    docfile.write(report[:body])
    docfile.close
    curl.http_post(Curl::PostField.file('upload[]', docfile.path)) while !file_uploaded
    File.unlink docfile.path
  end

  def up
    add_column :ordinances, :vfs_path, :string
    if Dir["#{Rails.root}/public/files"].any?
      require 'progress_bar'
      puts "Миграция приказов"
      bar = ProgressBar.new(Order.approved.count)
      Order.approved.find_each do |order|
        if File.exist?(path(order))
          upload(order)
          order.update_attribute :vfs_path, "/gpo/old_orders/order_#{order.id}.doc"
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
