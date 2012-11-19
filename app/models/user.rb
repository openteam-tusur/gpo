# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  email              :string(100)
#  created_at         :datetime
#  updated_at         :datetime
#  middle_name        :string(255)
#  first_name         :string(255)
#  last_name          :string(255)
#  post               :string(255)
#  chair_id           :integer
#  float              :string(255)
#  phone              :string(255)
#  uid                :string(255)
#  sign_in_count      :integer
#  current_sign_in_at :datetime
#  last_sign_in_at    :datetime
#  current_sign_in_ip :string(255)
#  last_sign_in_ip    :string(255)
#

class User < ActiveRecord::Base
  attr_accessible :first_name, :middle_name, :last_name, :email, :post, :float, :chair_id

  sso_auth_user

  belongs_to :chair
  has_many :project_managers


  has_many :leaderships, :class_name => 'ProjectManager'
  has_many :approved_leaderships, :class_name => 'ProjectManager', :conditions => {:state => ["approved", "awaiting_removal"]}
  has_many :projects, :through => :leaderships
  has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'

  has_many :permissions, :dependent => :destroy

  validates_presence_of :first_name, :middle_name, :last_name

  validates_uniqueness_of :email

  default_scope order('last_name, first_name, middle_name')

  def initials_name
    "#{last_name} #{first_name[0]}.#{middle_name[0]}."
  end

  def name
    [last_name, first_name, middle_name].reject(&:blank?).join(' ')
  end

  def available_chairs
    if manager?
      Chair.ordered_by_abbr
    elsif mentor?
      Chair.ordered_by_abbr.joins(:permissions).where(:permissions => {:user_id => self}).uniq
    elsif project_manager?
      Chair.ordered_by_abbr.joins(:projects).where(:projects => {:id => permissions.where(:context_type => 'Project').pluck(:context_id)}).uniq
    else
      Chair.where('1=0')
    end
  end

  def from_sso?
    uid?
  end
end
