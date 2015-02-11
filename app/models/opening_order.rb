class OpeningOrder < Order
  def available_projects
    chair.projects.draft.find_all do |project|
      project.opening_order.nil? || (project.opening_order == self && self.draft?)
    end
  end

  private

  def after_enter_approved
    super
    projects.map(&:approve!)
  end

end

# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  approved_at       :date
#  chair_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  state             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  file_url          :text
#
