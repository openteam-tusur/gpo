# encoding: utf-8
class OpeningOrder < Order
  
  def self.state_events
    Order.state_events
  end
  
  def available_projects
    self.chair.projects.draft.find_all do |project|
      project.opening_order.nil? || (project.opening_order == self && self.draft?)
    end
  end
  
  def title
    L10N[:opening_order][:title]
  end
  
  # для приказа
  def chairs_for_order_report
    chairs = []
    self.projects.each do |project|
      chairs.concat(project.participants.collect {|participant| participant.chair_abbr})
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

  def after_enter_approved
    self.projects.each do |project|
      p = Project.find(project.id)
      p.enable_modifications
      p.approve
    end
  end
end
