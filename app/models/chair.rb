# encoding: utf-8
# == Schema Information
#
# Table name: chairs
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  abbr       :string(255)
#  chief      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  faculty    :string(255)
#

require 'task'

class Chair < ActiveRecord::Base
  attr_accessible :title, :abbr, :chief

  validates_presence_of :title, :abbr, :chief
  validates_uniqueness_of :abbr

  has_many :projects, :order => 'cipher desc'
  has_many :orders, :order => 'id desc'
  has_many :workgroup_orders, :order => 'id desc'
  has_many :opening_orders, :order => 'id desc'
  has_many :users, :order => 'last_name'
  has_many :participants, :order => 'last_name', :through => :projects
  has_many :activities, :dependent => :destroy, :order => 'created_at desc', :limit => 10
  has_one :last_activity, :class_name => 'Activity', :order => 'created_at'

  has_many :permissions, :as => :context
  has_many :mentors, :through => :permissions, :conditions => ["permissions.role = ?", 'mentor'], :source => :user, :order => "last_name"

  scope :ordered_by_abbr, :order => "abbr"
  scope :ordered_by_title, :order => "title"
  scope :ordered_by_faculty, :order => "faculty, title"

  def id_to_s
    self.abbr
  end

  def project_managers
    User.joins(:project_managers).joins(:projects).where(:projects => { :chair_id => self }, :project_managers => { :state => :approved }).uniq
  end

  def stats(*types)
    Stat.for_chair(self, *types)
  end

  def tasks(user, context = nil)
    Task.tasks_for(user, self, context)
  end

  def xml_for_chair_statement_checkup
    self.to_xml(:skip_types => true, :root => "doc") do |xml|
      xml.chair_abbr self.abbr
      xml.chair_chief self.chief
      xml.count_participants self.participants.active.count
      xml.count_participants_3_4 self.participants.active.at_course(3).count + self.participants.active.at_course(4).count
      xml.count_participants_3 self.participants.active.at_course(3).count
      xml.count_participants_4 self.participants.active.at_course(4).count
      xml.count_project_managers User.count(:conditions => {:id => ProjectManager.active.find(:all, :conditions => {:project_id => self.projects.current_active.map(&:id)}).map(&:user_id)})
      xml.count_projects self.projects.current_active.count
      xml.mentor self.mentors.first.name
      xml.projects do |xml_project|
        self.projects.current_active.each do |project|
          xml.project do
            xml.cipher project.cipher
            xml.project_managers project.project_managers.active.active.map(&:user).map(&:name).join(", ")
            xml.count_participants_3 project.participants.active.at_course(3).count
            xml.count_participants_4 project.participants.active.at_course(4).count
          end
        end
      end
      xml.project_managers do |xml_project_manager|
        User.find(:all, :conditions => {:id => ProjectManager.active.find(:all, :conditions => {:project_id => self.projects.current_active.map(&:id)}).map(&:user_id)}).each do |user|
          xml.project_manager do
            xml.name user.name
          end
        end
      end
    end
  end

end
