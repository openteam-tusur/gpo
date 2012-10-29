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

  scope :current_active, where(:state => %w[draft active])

  before_create :set_cipher, :unless => :cipher?

  scope :active, where(:state => :active)
  scope :draft, where(:state => :draft)
  scope :closed, where(:state => :closed)

  state_machine :initial => :draft do
    event :approve do
      transition :draft => :active
    end
    event :close do
      transition :active => :closed
    end
    event :reopen do
      transition :closed => :active
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

  def id_to_s
    self.cipher
  end

  def visitations_problem?
    visitations_count = Visitation.count(:include => [:participant, :gpoday], :conditions => ["
        participants.project_id = #{self.id} AND visitations.rate IS NOT NULL
        AND gpodays.date < ?", Date.today - 7.days])
    days_count = Gpoday.count(:conditions => ["date < ?", Date.today - 7.days])
    visitations_count != days_count*self.participants.active.count
  end

  # для приказа
  def text_managers_for_order_report
    arr = self.managers.collect { |manager| manager.text_for_order_report }
    arr.join("; ")
  end

  private

  def after_enter_active
    managers.each(&:approve)
    participants.each(&:approve)
  end

  def after_enter_closed
    managers.destroy_all
  end

  def set_cipher
    year = Date.today.year % 100
    last_project = Project.where("cipher like '#{chair.abbr}-#{year}%'").order('cipher DESC').first
    last_number = last_project.try(:cipher).try(:[], -2..-1).to_i
    self.cipher = sprintf "%s-%d%02d", chair.abbr, year, last_number + 1
  end

end
