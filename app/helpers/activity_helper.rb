module ActivityHelper

  def activity_icon(activity)
    image_tag "activity_#{activity.action}.png", :title => activity_order_action(activity), :class => 'icon'
  end
  
  def activity_order_action(activity)
    l(:order_activity, "#{activity.action}")
  end
end
