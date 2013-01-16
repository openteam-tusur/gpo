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

require 'zip/zip'

class Order < ActiveRecord::Base
  include ConvertedReport

  attr_accessor :comment, :actor

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
      order.activities.create! action: transition.event, comment: order.comment, chair_id: order.chair_id, actor: order.actor
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

  def generate_odt(&block)
    Rails.logger.info("generate #{report_basename}.odt")
    template = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{report_prefix}.odt")

    erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", report_prefix, "content.xml"))

    Dir.mktmpdir do |dir|
      report_filepath = "#{dir}/#{report_basename}.odt"
      Zip::ZipOutputStream.open(report_filepath) do |zip_entry|
        template.each do |entry|
          Rails.logger.debug("[#{report_basename}.odt]: generating #{zip_entry} started")
          zip_entry.put_next_entry entry.name
          if entry.name == 'content.xml'
            zip_entry.write erb.result(binding)
          else
            zip_entry.print template.read(entry.name)
          end
          Rails.logger.debug("[#{report_basename}.odt]: generating #{zip_entry} completed")
        end
      end
      yield File.new(report_filepath)
    end
  end

  def order_reason
    "Представление заведующего кафедрой #{chair.abbr}; #{another_chair_abbrs} виза декана; виза ЦИОТ.".squish
  end

  protected

  def another_chair_abbrs
    chair_abbrs = chairs.pluck(:abbr).delete(chair.abbr)
    case chair_abbrs.length
    when 1
      "виза заведующего кафедрой #{chair_abbrs[0]}; "
    when 2
      "визы заведующих кафедрами #{chair_abbrs.join(', ')}; "
    end
  end


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
    generate_odt do |generated_odt|
      converted_report(generated_odt.path, :doc) do |converted_report|
        update_attributes!({:file => converted_report}, {:without_protection => true})
      end
    end
  end

  def report_prefix
    self.class.model_name.underscore
  end

  def report_basename
    "#{report_prefix}_#{id}"
  end
end
