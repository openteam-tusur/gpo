class Project < ActiveRecord::Base
  extend Enumerize
  attr_accessible :category, :title, :theme_id, :goal, :stakeholders, :funds_required, :funds_sources, :purpose,
    :features, :analysis, :novelty, :expected_results, :release_cost, :forecast, :source_data, :close_reason, :sbi_placing,
    :result, :closed_on

  belongs_to :chair
  belongs_to :theme

  has_many :participants, -> { order('last_name') }, :dependent => :destroy
  has_many :alien_participants, -> { order('last_name') }
  has_many :project_managers, :dependent => :destroy
  has_many :stages, -> { order('start') }, :dependent => :destroy
  has_many :people, -> { order('people.last_name') }, :through => :project_managers
  has_many :issues, :through => :participants

  has_many :order_projects, :dependent => :destroy
  has_many :orders, -> { order('orders.id desc') }, :through => :order_projects
  has_many :opening_orders, -> { where(['orders.type = ?', OpeningOrder.name]) }, :through => :order_projects, :source => :order
  has_many :workgroup_orders, -> { where(["orders.type = ?", WorkgroupOrder.name]).order('orders.approved_at desc') }, :through => :order_projects, :source => :order

  has_many :permissions, :as => :context, :dependent => :destroy

  validates_presence_of :title
  validates_presence_of :chair_id


  before_create :set_cipher, :unless => :cipher?

  before_destroy :destroyable?

  scope :current_active, -> { where(:state => %w[draft active]) }
  scope :active, -> { where(:state => :active) }
  scope :draft,  -> { where(:state => :draft) }
  scope :closed, -> { where(:state => :closed) }
  scope :editable, -> { where(:editable_state => :editable) }
  scope :sbi_residents, ->{ where(:sbi_placing => :resident) }
  scope :interdisciplinary, ->{ where(:interdisciplinary => [:interfaculty, :intersubfaculty]) }
  scope :interfaculty, -> {where(:interdisciplinary => :interfaculty)}
  scope :intersubfaculty, -> {where(:interdisciplinary => :intersubfaculty)}

  delegate :name, :to => :theme, :prefix => true, :allow_nil => true

  searchable do
    text(:title, :stored => true)
    text(:project_managers)         { project_managers.map(&:person).join(' ') }
    text(:participants)             { participants.map {|p| p.name_with_group }.join(' ') }
    string(:chair)                  { chair.abbr if chair}
    string(:theme)                  { theme.name if theme }
    string(:state)                  { state }
    string(:category)               { category }
    string(:interdisciplinary)      { self.interdisciplinary }
    boolean(:sbi_resident)          { self.sbi_placing.try(:resident?) }
  end

  scope :for_user, ->(user) do
    if user.mentor?
      where(:chair_id => user.available_chairs.all)
    elsif user.project_manager?
      joins(:project_managers).joins(:people).where(:project_managers => { :state => :approved }, :people => { :user_id => user.id }).uniq
    end
  end

  enumerize :sbi_placing, in: [:resident, :not_related], predicates: { prefix: true }
  enumerize :interdisciplinary, in: [:intersubfaculty, :interfaculty, :not_interdisciplinary], default: :not_interdisciplinary, predicates: true
  enumerize :category, in: [:business, :research, :by_request, :for_university, :social], predicates: true
  enumerize :result, :in => [:programm, :device, :model, :method, :technology, :none, :other]

  state_machine :initial => :draft do
    state :closed do
      validates_presence_of :close_reason, :result
    end

    event :approve do
      transition :draft => :active
    end

    event :close do
      transition :active => :closed, :if => :closeable?
    end

    event :reopen do
      transition :closed => :active
    end

    after_transition :draft => :active do |project, transition|
    end

    after_transition any => :closed do |project, transition|
      project.disable_modifications!
      project.project_managers.destroy_all
      project.set_closed_on
    end

    after_transition :closed => :active do |project, transition|
      project.enable_modifications!
      project.reset_result_and_closed_on
    end
  end

  state_machine :editable_state, :initial => :editable do
    event :disable_modifications do
      transition :editable => :blocked
    end

    event :enable_modifications do
      transition :blocked => :editable
    end
  end

  def stats(*types)
    Stat.for_project(self, *types)
  end

  def opening_order
    opening_orders.first
  end

  def id_to_s
    self.cipher
  end

  def to_s
    "#{cipher} #{title}"
  end

  def visitations_problem?
    visitations_count = Visitation.count(:include => [:participant, :gpoday], :conditions => ["
        participants.project_id = #{self.id} AND visitations.rate IS NOT NULL
        AND gpodays.date < ?", Date.today - 7.days])
    days_count = Gpoday.count(:conditions => ["date < ?", Date.today - 7.days])
    visitations_count != days_count*self.participants.active.count
  end

  # для приказа
  def text_project_managers_for_order_report
    arr = self.project_managers.collect { |project_manager| project_manager.text_for_order_report }
    arr.join("; ")
  end

  def closeable?
    participants.empty?
  end

  def destroyable?
    (draft? && participants.empty?) || closed?
  end

  def update_interdisciplinary
    self.interdisciplinary = 'not_interdisciplinary'
    if participants.active.any?
      self.interdisciplinary = 'intersubfaculty' if participants.active.group_by(&:subfaculty).size > 1 || !participants.active.group_by(&:subfaculty).keys.include?(chair.abbr)
      self.interdisciplinary = 'interfaculty' if participants.active.group_by(&:faculty).size > 1 || !participants.active.group_by(&:faculty).keys.include?(chair.faculty_abbr)
    end
    save if self.interdisciplinary_changed?
  end

  def set_closed_on
    update_attribute :closed_on, Date.today
  end

  def reset_result_and_closed_on
    update_attributes :result => nil, :closed_on => nil
  end

  private

  def set_cipher
    year = Date.today.year % 100
    last_project = Project.where("cipher like ?", "#{chair.abbr}-#{year}%").order('cipher DESC').first
    last_number = last_project.try(:cipher).try(:[], -2..-1).to_i
    self.cipher = sprintf "%s-%d%02d", chair.abbr, year, last_number + 1
  end

  def xml_for_project_tz
    self.to_xml(:skip_types => true, :root => "doc") do |xml|
      xml.chair_abbr self.chair.abbr
      xml.chair_chief self.chair.chief
      xml.opened_order_approved_at (self.opening_order && self.opening_order.approved_at) ? I18n.l(self.opening_order.approved_at) : ''
      xml.opened_order_number self.opening_order ? self.opening_order.number : ''
      xml.theme_name self.theme ? self.theme.name : ''
      xml.funds_sources self.funds_sources
      xml.source_data self.source_data
      xml.chief self.people.empty? ? '' : "#{self.people[0].initials_name}, #{self.people[0].post}"
      xml.chief_name self.people.empty? ? '' : "#{self.people[0].initials_name}"
      xml.participants do |xml_participant|
        self.participants.active.each do |participant|
          xml.participant do
            xml.name participant.name
            xml.edu_group participant.edu_group
          end
        end
      end
      xml.stages do |xml_stage|
        self.stages.each do |stage|
          xml.stage do
            xml.title stage.title
            xml.activity stage.activity
            xml.results stage.results
            xml.start I18n.l(stage.start)
            xml.finish I18n.l(stage.finish)
          end
        end
      end
    end
  end
end

# == Schema Information
#
# Table name: projects
#
#  id                :integer          not null, primary key
#  cipher            :string(255)
#  title             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  chair_id          :integer
#  stakeholders      :text
#  funds_required    :text
#  funds_sources     :text
#  purpose           :text
#  features          :text
#  analysis          :text
#  novelty           :text
#  expected_results  :text
#  release_cost      :text
#  forecast          :text
#  state             :string(255)
#  editable_state    :string(255)
#  close_reason      :text
#  theme_id          :integer
#  goal              :text
#  source_data       :text
#  sbi_placing       :string(255)
#  interdisciplinary :string(255)
#  category          :string(255)
#  result            :string(255)
#  closed_on         :date
#
