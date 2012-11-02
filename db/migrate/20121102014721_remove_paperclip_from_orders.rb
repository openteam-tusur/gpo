# encoding: utf-8

class RemovePaperclipFromOrders < ActiveRecord::Migration
  include SendReport
  BASE_URL="#{Settings['storage.url']}/api/el_finder/v2/"
  # gpo/old_orders/

  def upload(order)
    #debugger
    curl = Curl::Easy.new("#{BASE_URL}?cmd=upload&target=r1_Z3BvL29sZF9vcmRlcnM") do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.multipart_form_post = true
    end
    docfile = File.open("/tmp/order_#{order.id}.doc", 'wb')
    docfile.write(convert_report("#{Rails.root}/public/files/order_#{order.id}.odt", :doc)[:body])
    docfile.close
    curl.http_post(Curl::PostField.file('upload[]', docfile.path))
    File.unlink docfile.path
  end

  def up
    add_column :ordinances, :vfs_path, :string
    if Dir["#{Rails.root}/public/files"].any?
      require 'progress_bar'
      puts "Миграция приказов"
      bar = ProgressBar.new(Order.approved.count)
      Order.approved.find_each do |order|
        upload(order)
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
