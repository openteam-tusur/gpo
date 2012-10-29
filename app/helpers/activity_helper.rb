# encoding: utf-8

module ActivityHelper

  def activity_icon(activity)
    image_tag "activity_#{activity.try(:action)}.png", :title => activity_order_action(activity), :class => "icon", :size => "16x16"
  end

  def activity_order_action(activity)
    I18n.t("order_activity.#{activity.try(:action)}")
  end
end
