class Stage < ActiveRecord::Base
  belongs_to :project
  validates_presence_of :title, :start, :finish

  protected
  def self.allowed?(user, project)
    user.is_a?(User) && project.updatable_by?(user)
  end
end
