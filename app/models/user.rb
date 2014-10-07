class User
  include AuthClient::User
  #attr_accessible :first_name, :middle_name, :last_name, :email, :phone, :post, :float, :chair_id

  #sso_auth_user

  #belongs_to :chair
  #has_many :project_managers

  #has_many :leaderships, :class_name => 'ProjectManager', :dependent => :destroy
  #has_many :approved_leaderships, :class_name => 'ProjectManager', :conditions => {:state => ["approved", "awaiting_removal"]}
  #has_many :projects, :through => :leaderships
  #has_many :managable_projects, :source => :project, :through => :approved_leaderships, :order => 'cipher desc'

  #has_many :permissions, :dependent => :destroy

  #validates_presence_of :first_name, :middle_name, :last_name, :unless => :from_sso?

  #validates_uniqueness_of :email, :allow_nil => true

  #normalize_attribute :email, :first_name, :middle_name, :last_name, :post, :float, :phone

  #default_scope order('last_name, first_name, middle_name')

  #def initials_name
    #@initials_name ||= "#{last_name} #{initials}"
  #end

  #def initials
    #@initials ||= [first_name.try(:first), middle_name.try(:first)].select(&:present?).map{|letter| "#{letter}."}.join
  #end

  #def name
    #[last_name, first_name, middle_name].reject(&:blank?).join(' ')
  #end

  #def available_chairs
    #if manager?
      #Chair.ordered_by_abbr
    #elsif mentor?
      #Chair.ordered_by_abbr.joins(:permissions).where(:permissions => {:user_id => self}).uniq
    #elsif project_manager?
      #Chair.ordered_by_abbr.joins(:projects).where(:projects => {:id => permissions.where(:context_type => 'Project').pluck(:context_id)}).uniq
    #else
      #Chair.where('1=0')
    #end
  #end

  #def from_sso?
    #uid?
  #end
end
