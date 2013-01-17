# encoding: utf-8

require 'progress_bar'
require 'timecop'


def odt_filepath(order)
  "#{Rails.root}/public/files/order_#{order.id}.odt"
end

def orders
  @orders ||= Order.where("state != 'draft'").where('file_url IS NULL OR file_file_size = 0')
end

def bar
  @bar ||= ProgressBar.new(orders.count)
end

desc "Миграция приказов"
task :migrate_orders => :environment do
  include ConvertedReport

  Order.record_timestamps = false

  orders.find_each do |order|
    if File.exist?(odt_filepath(order))
      converted_report(odt_filepath(order), :doc) do |doc_file|
        Timecop.freeze order.approved_at do
          order.update_attributes!({:file => doc_file}, {:without_protection => true})
        end
      end
    else
      puts "нет файла приказа #{order.id}"
    end
    bar.increment!
  end
end
