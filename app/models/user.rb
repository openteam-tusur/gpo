require 'digest/sha1'

class User < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken

  #validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40, :if => :login_validation?
  validates_uniqueness_of   :login, :if => :login_validation?
  validates_format_of       :login, :with => Authentication.login_regex, :message => Authentication.bad_login_message, 
                                    :if => :login_validation?
  
  validates_presence_of     :first_name, :mid_name, :last_name

  #validates_presence_of     :email
  validates_length_of       :email, :within => 6..100, :if => :email_validation?
  validates_uniqueness_of   :email, :if => :email_validation?
  validates_format_of       :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message, 
                                    :if => :email_validation?

  belongs_to :chair
  
  # TODO: переименовать :managers в :leaderships
  has_many :leaderships, :class_name => 'Manager'
  has_many :approved_leaderships, :class_name => 'Manager', :conditions => {:state => ["approved", "awaiting_removal"]}
  has_many :projects, :through => :leaderships
  has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'
  
  has_many :rules, :dependent => :destroy
  
  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :post, :float, :phone, :first_name, :mid_name, :last_name, :password, :password_confirmation, :chair_id

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #

  def login_validation?
    !login.blank?
  end

  def email_validation?
    !email.blank? || !login.blank?
  end

  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) && !u.rules.empty? ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def name
    "#{last_name} #{first_name} #{mid_name}"
  end
  
  def initials_name
    "#{last_name} #{first_name.split(//u)[0,1].join}.#{mid_name.split(//u)[0,1].join}."
  end

  def initialize(attributes = {})
    super(attributes)
    if attributes.has_key?(:name)
      name = attributes[:name]
      self.last_name = name.split(" ")[0]
      self.first_name = name.split(" ")[1]
      self.mid_name = name.split(" ")[2]
    end
  end
  
   def role_symbols
     roles = (rules || []).map {|r| r.role.to_sym}
     roles << 'user'
   end

  
  def admin?
    self.rules.administrators.find(:first) != nil
  end

  def supervisor?
    self.rules.supervisors.find(:first) != nil
  end
  
  def any_mentor?
    self.rules.mentors.find(:first) != nil
  end
  
  def any_manager?
    self.rules.managers.find(:first) != nil
  end

  def mentor?(chair)
    self.rules.mentors.for_chair(chair).find(:first) != nil
  end

  def manager?(project)
    self.rules.managers.for_project(project).find(:first) != nil
  end
  
  def manager_at_chair?(chair)
    self.projects.all.find {|project| project.chair == chair} != nil
  end
  
  def manage_not_closed_projects?
    !(self.projects.active.empty? && self.projects.draft.empty?)
  end
  
  def chairs_for_mentor
    self.rules.mentors.collect {|rule| rule.chair}
  end

end
