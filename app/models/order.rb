# encoding: utf-8

# == Schema Information
#
# Table name: ordinances
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
#


class Order < ActiveRecord::Base
  set_table_name "ordinances"

  has_many :order_projects, :dependent => :destroy
  has_many :projects, :through => :order_projects, :order => 'cipher desc'
  has_many :activities, :as => :context, :dependent => :destroy, :order => 'created_at desc'

  belongs_to :chair

  # FIXME: + dragonfly || esp storage
  #has_attached_file :file, :path => ":rails_root/public/:attachment/order_:id.:extension", :url => "/:attachment/order_:id.:extension"

  validates_presence_of :number, :approved_at, :if => :approved?

  scope :blocking, where(:state => %w[being_reviewed reviewed])
  scope :not_approved, where(:state => %w[draft being_reviewed reviewed])
  scope :approved, where(:state => :approved)

  state_machine :initial => :draft do
    event :remove do
      transition :draft => :removed, :being_reviewed => :removed, :reviewed => :removed, :approved => :removed
    end
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
    after_transition  any => :draft,          :do => :after_enter_draft
    after_transition  any => :removed,        :do => :after_enter_removed
    after_transition  any => :approved,       :do => :after_enter_approved
    after_transition  any => :being_reviewed, :do => :after_enter_being_reviewed
  end

  def title
    raise "Некорректный тип приказа. Невозможно отобразить название приказа."
  end

  def order_type
    self.class.name
  end

  def update_projects(ids)
    self.projects = []
    unless ids.nil?
      ids.each { |id|
        self.projects << Project.find(id)
      }
    end
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

  def activity!(action, actor, comment)
    self.activities.create(:action => action.to_s, :actor => actor, :comment => comment, :chair => self.chair)
  end

  protected

  def after_enter_removed
    release_projects! if was_being_reviewed? || was_reviewed?
    self.destroy
  end

  def after_enter_being_reviewed
    block_projects!
    assign_file! unless self.file?
  end

  def after_enter_draft
    release_projects!
    remove_file! if self.file?
  end

  def after_enter_approved
  end

  def release_projects!
    self.projects.each { |p| p.enable_modifications }
  end

  def block_projects!
    self.projects.each { |p| p.disable_modifications }
  end

  def validate
    errors.add("projects", "Должен быть выбран хотя бы один проект") if self.projects.empty?
  end
end
