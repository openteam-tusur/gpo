class Project < ActiveRecord::Base
  belongs_to :chair
  belongs_to :theme

  has_many :participants, :dependent => :destroy, :order => "last_name"
  has_many :managers, :dependent => :destroy
  has_many :stages, :dependent => :destroy, :order => "start"
  has_many :users, :through => :managers, :order => "last_name"

  has_many :order_projects, :dependent => :destroy
  has_many :orders, :through => :order_projects, :order => "ordinances.id desc"
  has_one :opening_order, :through => :order_projects, :conditions => ["ordinances.type = ?", OpeningOrder.name], :source => :order
  has_many :workgroup_orders, :through => :order_projects, :conditions => ["ordinances.type = ?", WorkgroupOrder.name], :source => :order, :order => "ordinances.approved_at desc"

  validates_presence_of :title
  validates_presence_of :chair_id

  validates_presence_of :close_reason, :if => :closed?

  has_states :draft, :active, :closed do
    on :approve do
      transition :draft => :active
    end
    on :close do
      transition :active => :closed
    end
    on :reopen do
      transition :closed => :active
    end
  end

  has_states :editable, :blocked, :in => :editable_state do
    on :disable_modifications do
      transition :editable => :blocked
    end
    on :enable_modifications do
      transition :blocked => :editable
    end
  end

  named_scope :current_active, :conditions => {:state => ['draft', 'active' ]}

  def stats(*types)
    Stat.for_project(self, *types)
  end

  def id_to_s
    self.cipher
  end

  def before_create
    if self.cipher.blank?
      year = Time.now.year.to_s[2..3]
      last_project = Project.find(:first, :conditions => "cipher like '#{chair.abbr}-#{year}%'", :order => "cipher DESC")
      if last_project.nil?
        cipher = "#{chair.abbr}-#{year}01"
      else
        max_iter = last_project.cipher[-2..-1].to_i
        max_iter += 1
        cipher = "#{chair.abbr}-#{year}#{max_iter > 9 ? max_iter.to_s : '0' + max_iter.to_s}"
      end
      self.cipher = cipher
    end
  end

  def after_enter_active
    self.managers.each do |manager|
      manager.approve
    end
    self.participants.each do |participant|
      participant.approve
    end
  end

  def visitations_problem?
    visitations_count = Visitation.count(:include => [:participant, :gpoday], :conditions => ["
        participants.project_id = #{self.id} AND visitations.rate IS NOT NULL
        AND gpodays.date < ?", Date.today - 7.days])
    days_count = Gpoday.count(:conditions => ["date < ?", Date.today - 7.days])
    visitations_count != days_count*self.participants.active.count
  end

  def after_enter_closed
    self.managers.destroy_all
  end

  def editable_state_description
    L10N[:project]["editable_state_#{self.editable_state}"]
  end

  def state_description
    L10N[:project]["state_#{self.state}"]
  end

  # для приказа
  def text_managers_for_order_report
    arr = self.managers.collect { |manager| manager.text_for_order_report }
    arr.join("; ")
  end

end

