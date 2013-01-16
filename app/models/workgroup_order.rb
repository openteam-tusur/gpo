# encoding: utf-8
# == Schema Information
#
# Table name: orders
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
#  file_url          :text
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
end
