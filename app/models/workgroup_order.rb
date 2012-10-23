# encoding: utf-8
class WorkgroupOrder < Order
  
  def self.state_events
    Order.state_events
  end
  
  def available_projects
    self.chair.projects.active.editable.find_all do |project|
      # в проекте есть изменения в участниках
      # с проектом не свзяано других неутвержденных приказо об изменении рабочих групп
      !project.participants.awaiting.empty? &&
      (project.workgroup_orders.not_approved.empty? || project.workgroup_orders.include?(self))
    end
  end
  
  def title
    L10N[:workgroup_order][:title]
  end

  def after_enter_approved
    self.projects.each do |project|
      project.enable_modifications
      project.participants.awaiting.each do |participant|
        participant.approve
      end
    end
  end

  # для приказа
  def chairs_for_order_report
    chairs = []
    self.projects.each do |project|
      chairs.concat(project.participants.awaiting_approval.collect {|participant| participant.chair_abbr})
      chairs.concat(project.participants.awaiting_removal.collect {|participant| participant.chair_abbr})
    end
    chairs.uniq!
    chairs.delete(self.chair.abbr)
    case chairs.length
    when 1
      "виза заведующего кафедрой #{chairs[0]}; "
    when 2
      "визы заведующих кафедрами #{chairs.join(', ')}; "
    end
  end
end
