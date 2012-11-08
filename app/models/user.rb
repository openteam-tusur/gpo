class User < ActiveRecord::Base
  attr_accessible :mid_name, :post, :float, :chair_id
  esp_auth_user

  belongs_to :chair

  has_many :leaderships, :class_name => 'ProjectManager'
  has_many :approved_leaderships, :class_name => 'ProjectManager', :conditions => {:state => ["approved", "awaiting_removal"]}
  has_many :projects, :through => :leaderships
  has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'

  has_many :permissions, :dependent => :destroy

  default_scope order('last_name, first_name, mid_name')

  def initials_name
    "#{last_name} #{first_name.split(//u)[0,1].join}.#{mid_name.split(//u)[0,1].join}."
  end

  def manage_not_closed_projects?
    !(self.projects.active.empty? && self.projects.draft.empty?)
  end

  def chairs_for_mentor
    self.rules.mentors.collect {|rule| rule.chair}
  end

  def available_chairs
    Chair.ordered_by_abbr
  end
end

# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  uid                :string(255)
#  name               :text
#  email              :text
#  nickname           :text
#  first_name         :text
#  last_name          :text
#  location           :text
#  description        :text
#  image              :text
#  phone              :text
#  urls               :text
#  raw_info           :text
#  sign_in_count      :integer         default(0)
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

