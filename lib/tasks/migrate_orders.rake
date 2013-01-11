# encoding: utf-8

require 'progress_bar'
require 'timecop'

def odt_filepath(order)
  "#{Rails.root}/public/files/order_#{order.id}.odt"
end

def orders
  @orders ||= Order.approved.where('file_url IS NULL')
end

def bar
  @bar ||= ProgressBar.new(orders.count)
end

namespace :legacy do
  desc "Миграция приказов"
  task :migrate_orders => :environment do
    Order.record_timestamps = false

    orders.find_each do |order|
      if File.exist?(odt_filepath(order))
        Timecop.freeze order.approved_at do
          order.update_attributes!({:file => File.new(odt_filepath(order))}, {:without_protection => true})
        end
      else
        puts "нет файла приказа #{order.id}"
      end
      bar.increment!
    end
  end
end
