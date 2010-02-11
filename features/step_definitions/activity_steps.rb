Then /^у приказа должна зафиксироваться деятельность "(.*)" с комментарием "(.*)"$/ do |action, comment|
  order = Order.find(:first)
  activity = Activity.for_order(order.id)[0]
  assert !activity.nil?, "запись не зафиксировалась"
  assert_equal action, activity.action
  assert_equal comment, activity.comment
end

Then /^в базе не должно быть активностей$/ do
  assert Activity.find(:all).empty?, 'в базе есть активности'
end

# TODO переписать
Then /^я вижу активность "([\w\s]+)"(?:, объект "([\w\s]+)")?, актер "([\w\s]+)"(?:, с комментарием "([\w\s]+)")?$/ do |action, object, actor, comment|
  found = false
  Nokogiri::HTML(response.body).search(".activity, .activity_short").each do |scope|
    found = scope.to_s.include?(action) &&
      scope.to_s.include?(actor) &&
      (object.blank? ? true : scope.to_s.include?(object)) &&
      (comment.blank? ? true : scope.to_s.include?(comment))
    break if found
  end
  assert found
end
