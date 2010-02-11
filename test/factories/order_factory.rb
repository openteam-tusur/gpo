Factory.define :OpeningOrder do |order|
  order.chair_id { |chair| chair.association(:chair).id }
  order.projects :projects
end

Factory.define :WorkgroupOrder do |order|
  order.chair_id { |chair| chair.association(:chair).id }
  order.projects :projects
end
