# encoding: utf-8
# == Schema Information
#
# Table name: ordinances
#
#  id          :integer          not null, primary key
#  number      :string(255)
#  approved_at :date
#  chair_id    :integer
#  created_at  :datetime
#  updated_at  :datetime
#  type        :string(255)
#  state       :string(255)
#  vfs_path    :string(255)
#

class WorkgroupOrder < Order
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
      chairs.concat(project.participants.awaiting.collect {|participant| participant.chair_abbr})
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
