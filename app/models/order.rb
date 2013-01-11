# encoding: utf-8
# == Schema Information
#
# Table name: orders
#
#  id                :integer          not null, primary key
#  number            :string(255)
#  approved_at       :date
#  chair_id          :integer
#  created_at        :datetime
#  updated_at        :datetime
#  type              :string(255)
#  state             :string(255)
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :date
#  file_url          :text
#


class Order < ActiveRecord::Base
  include SendReport
  include GenerateOdt


  attr_accessor :comment

  attr_accessible :project_ids, :state_event, :number, :approved_at, :comment

  before_destroy :unlock_projects!, :if => :being_reviewed?

  has_many :order_projects, :dependent => :destroy
  has_many :projects, :through => :order_projects, :order => 'cipher DESC'
  has_many :participants, :through => :projects
  has_many :project_managers, :through => :projects
  has_many :chairs, :through => :participants, :uniq => true
  has_many :activities, :as => :context, :dependent => :destroy, :order => 'created_at DESC'

  belongs_to :chair

  validates_presence_of :projects

  scope :blocking, where(:state => %w[being_reviewed reviewed])
  scope :not_approved, where(:state => %w[draft being_reviewed reviewed])
  scope :approved, where(:state => :approved)
  scope :draft, where(:state => :draft)

  has_attached_file :file, :storage => :elvfs, :elvfs_url => Settings['storage.url']

  state_machine :initial => :draft do
    event :to_review do
      transition :draft => :being_reviewed
    end

    event :cancel do
      transition :being_reviewed => :draft, :reviewed => :draft
    end

    event :review do
      transition :being_reviewed => :reviewed
    end

    event :approve do
      transition :reviewed => :approved
    end

    state :approved do
      validates_presence_of :number, :approved_at
    end

    after_transition  any => :draft,          :do => :after_enter_draft
    after_transition  any => :being_reviewed, :do => :after_enter_being_reviewed
    after_transition  any => :approved,       :do => :after_enter_approved

    after_transition do |order, transition|
      order.activities.create! action: transition.event, comment: order.comment, chair_id: order.chair_id
    end
  end

  def title
    self.class.model_name.human
  end

  def order_type
    self.class.name
  end

  def projects_to_s
    ret = self.projects.collect { |p| p.cipher }
    if ret.length > 3
      left = ret.length - 2
      ret = ret[0..1]
      ret << "ещё #{left} #{Order.pluralized_string(left)}"
    end
    ret.to_sentence
  end

  def self.pluralized_string(n)
    Russian.p(n, 'проект', 'проекта', 'проектов')
  end

  def state_events_for(user)
    state_events.select{ |event| Ability.new(user).can?(event.to_sym, self) }
  end

  protected

  def after_enter_being_reviewed
    lock_projects!
    upload_file
  end

  def after_enter_draft
    unlock_projects!
    update_attributes({:file => nil}, {:without_protection => true})
  end

  def after_enter_approved
    unlock_projects!
    approve_awaiting_project_managers_and_participants!
  end

  def unlock_projects!
    projects.map(&:enable_modifications!)
  end

  def lock_projects!
    projects.map(&:disable_modifications!)
  end

  def approve_awaiting_project_managers_and_participants!
    project_managers.awaiting.each(&:approve!)
    participants.awaiting.each(&:approve!)
  end

  def upload_file
    generated_odt ||= generate_odt(self).path
    report = {}
    while report[:content_type] != 'application/msword'
      report = convert_report(generated_odt, :doc)
    end

    docfile.write(report[:body])
    docfile.close

    update_attributes! :file => docfile

    File.unlink docfile.path
  end
end
