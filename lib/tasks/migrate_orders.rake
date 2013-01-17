# encoding: utf-8

require 'progress_bar'
require 'timecop'


def odt_filepath(order)
  "#{Rails.root}/public/files/order_#{order.id}.odt"
end

def orders
  @orders ||= Order.where("state <> 'draft'").where("file_updated_at < created_at")
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

  orders.all.each do |order|
    if File.exist?(odt_filepath(order))
      Timecop.freeze(order.created_at + 1.second) do
        converted_report(odt_filepath(order), :doc) do |doc_file|
          order.update_attributes!({:file => nil}, {:without_protection => true})
          order.update_attributes!({:file => doc_file}, {:without_protection => true})
        end
      end
    else
      puts "нет файла приказа #{order.id}"
    end
    bar.increment!
  end
end
