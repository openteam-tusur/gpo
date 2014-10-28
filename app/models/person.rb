class Person < ActiveRecord::Base
  attr_accessible :first_name, :middle_name, :last_name, :email, :phone, :post, :float, :chair_id

  belongs_to :chair

  has_many :project_managers,                                                                                                 :dependent => :destroy
  has_many :leaderships,                                                                  :class_name => 'ProjectManager',    :dependent => :destroy
  has_many :approved_leaderships,  -> { where(:state => %w(approved awaiting_removal)) }, :class_name => 'ProjectManager'
  has_many :projects,                                                                                                                                   :through => :leaderships
  has_many :managable_projects,    -> { order('cipher desc')},                            :source => :project,                                          :through => :approved_leaderships

  validates_presence_of   :first_name, :middle_name, :last_name, :unless => :from_sso?
  validates_uniqueness_of :email, :allow_nil => true, :scope => [:chair_id]

  normalize_attributes :email, :first_name, :middle_name, :last_name, :post, :float, :phone

  default_scope order('last_name, first_name, middle_name')

  def user
    @user ||= User.find_by(:id => user_id)
  end

  def initials_name
    @initials_name ||= "#{last_name} #{initials}"
  end

  def initials
    @initials ||= [first_name.try(:first), middle_name.try(:first)].select(&:present?).map{|letter| "#{letter}."}.join
  end

  def from_sso?
    user.present?
  end

  def to_s
    [last_name, first_name, middle_name].join(' ')
  end
end
