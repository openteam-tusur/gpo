# encoding: utf-8

# == Schema Information
#
# Table name: projects
#
#  id               :integer          not null, primary key
#  cipher           :string(255)
#  title            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  chair_id         :integer
#  stakeholders     :text
#  funds_required   :text
#  funds_sources    :text
#  purpose          :text
#  features         :text
#  analysis         :text
#  novelty          :text
#  expected_results :text
#  release_cost     :text
#  forecast         :text
#  state            :string(255)
#  editable_state   :string(255)
#  close_reason     :text
#  theme_id         :integer
#  goal             :text
#  source_data      :text
#

class Project < ActiveRecord::Base
  attr_accessible :title, :theme_id, :goal, :stakeholders, :funds_required, :funds_sources, :purpose,
    :features, :analysis, :novelty, :expected_results, :release_cost, :forecast, :source_data, :close_reason

  belongs_to :chair
  belongs_to :theme

  has_many :participants, :dependent => :destroy, :order => "last_name"
  has_many :project_managers, :dependent => :destroy
  has_many :stages, :dependent => :destroy, :order => "start"
  has_many :users, :through => :project_managers, :order => "last_name"
  has_many :issues, :through => :participants

  has_many :order_projects, :dependent => :destroy
  has_many :orders, :through => :order_projects, :order => "ordinances.id desc"
  has_many :opening_orders, :through => :order_projects, :conditions => ["ordinances.type = ?", OpeningOrder.name], :source => :order
  has_many :workgroup_orders, :through => :order_projects, :conditions => ["ordinances.type = ?", WorkgroupOrder.name], :source => :order, :order => "ordinances.approved_at desc"

  validates_presence_of :title
  validates_presence_of :chair_id

  scope :current_active, where(:state => %w[draft active])

  before_create :set_cipher, :unless => :cipher?

  before_destroy :destroyable?

  scope :active, where(:state => :active)
  scope :draft, where(:state => :draft)
  scope :closed, where(:state => :closed)
  scope :editable, where(:editable_state => :editable)

  scope :for_user, ->(user) do
    if user.project_manager?
      joins(:project_managers).where(:project_managers => { :user_id => user }).uniq
    elsif user.mentor?
      where(:chair_id => user.available_chairs)
    end
  end

  state_machine :initial => :draft do
    state :closed do
      validates_presence_of :close_reason
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
    end

    after_transition :closed => :active do |project, transition|
      project.enable_modifications!
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
    closed?
  end

  private

  def set_cipher
    year = Date.today.year % 100
    last_project = Project.where("cipher like '#{chair.abbr}-#{year}%'").order('cipher DESC').first
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
      xml.chief self.users.empty? ? '' : "#{self.users[0].initials_name}, #{self.users[0].post}"
      xml.chief_name self.users.empty? ? '' : "#{self.users[0].initials_name}"
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
