# encoding: utf-8

# == Schema Information
#
# Table name: ordinances
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  approved_at       :date
#  chair_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  type              :string(255)
#  state             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :date
#

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

  private

  # TODO: ensure this method invokes
  def after_enter_approved
    self.projects.each do |project|
      project.enable_modifications
      project.participants.awaiting.each do |participant|
        participant.approve
      end
    end
  end
end
