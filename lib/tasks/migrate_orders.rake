# encoding: utf-8

require 'progress_bar'
require 'timecop'


def odt_filepath(order)
  "#{Rails.root}/public/files/order_#{order.id}.odt"
end

def orders
  @orders ||= Order.where("state <> 'draft'").where("file_url IS NULL OR file_file_size = 0 OR updated_at < ? OR approved_at IS NULL OR approved_at < ?", first_order_date, first_order_date.to_date)
end

def bar
  @bar ||= ProgressBar.new(orders.count)
end

def first_order_date
  @first_order_date ||= Order.order(:id).first.created_at
end

desc "Миграция приказов"
task :migrate_orders => :environment do
  include ConvertedReport

  Order.record_timestamps = false

  orders.all.each do |order|
    order.updated_at = order.created_at if order.updated_at < first_order_date
    order.approved_at = order.updated_at.to_date if order.approved_at && order.approved_at < first_order_date.to_date
    if File.exist?(odt_filepath(order))
      converted_report(odt_filepath(order), :doc) do |doc_file|
        Timecop.freeze(order.approved_at || order.updated_at) do
          order.update_attributes!({:file => doc_file}, {:without_protection => true})
        end
      end
    else
      puts "нет файла приказа #{order.id}"
    end
    bar.increment!
  end
end
