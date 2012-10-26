# encoding: utf-8

# == Schema Information
#
# Table name: participants
#
#  id                :integer          not null, primary key
#  student_id        :integer
#  state             :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  project_id        :integer
#  course            :integer
#  chair_id          :integer
#  first_name        :string(255)
#  mid_name          :string(255)
#  last_name         :string(255)
#  chair_abbr        :string(255)
#  edu_group         :string(255)
#  contingent_active :boolean
#  contingent_gpo    :boolean
#

class Participant < ActiveRecord::Base
  validates_presence_of :student_id
  validates_presence_of :project_id

  belongs_to :student
  belongs_to :project
  belongs_to :chair
  has_many :visitations,  :dependent => :destroy
  has_many :issues,       :order => :planned_closing_at,                                         :dependent => :destroy

  scope :ordered,         order(:last_name)
  scope :active,          where(:state => %w[approved awaiting_removal]).ordered
  scope :awaiting,        where(:state => %w[awaiting_approval awaiting_removal])
  scope :problematic,     where('(state in (?) AND contingent_gpo = ?) OR contingent_active = ?',  %w[approved awaiting_removal],  false,  false).ordered
  scope :at_course,       ->(course) { where(:course => course) }
  scope :for_student,     ->(id)     { where(:student_id => id) }

  before_create :update_from_contingent

  state_machine :initial => :awaiting_approval do
    event :approve do
      transition :awaiting_approval => :approved, :awaiting_removal => :removed
    end
    event :cancel do
      transition :awaiting_approval => :removed, :awaiting_removal => :approved
    end
    event :remove do
      transition :approved => :awaiting_removal
    end
    after_transition all => :removed do
      destroy
    end
  end

  # FIXME: - l10n
  def state_description
    #L10N[:participant]["state_#{self.state}"]
  end

  def name
    "#{self.last_name} #{self.first_name} #{self.mid_name}"
  end

  def problems
    [].tap do | problems |
      problems << %q(Не числится учащимся в АИС "Контингент") unless contingent_active?
      problems << %q(Не числится в ГПО в АИС "Контингент") if (approved? || awaiting_removal?) && !contingent_gpo?
    end
  end

  def update_from_contingent
    self.first_name        = student.first_name
    self.mid_name          = student.mid_name
    self.last_name         = student.last_name
    self.chair_abbr        = student.chair_abbr
    self.edu_group         = student.edu_group
    self.course            = student.course
    self.contingent_active = student.active
    self.contingent_gpo    = student.gpo
    self.chair_id          = project.chair_id
  end

  def self.update_from_contingent
    self.find(:all).each do |participant|
      participant.update_from_contingent
      participant.save
    end
  end

  def visitation_for_gpoday(gpoday)
    self.visitations.find_or_create_by_gpoday_id(gpoday.id)
  end

  # для приказа
  def text_for_order_report
    "#{self.name}, гр. #{self.edu_group}, каф. #{self.chair_abbr}"
  end

  def self.pluralized_string(count)
    Russian.p(count, 'участник', 'участника', 'участников')
  end

  def can_create?
    unless self.student.nil?
      result = self.class.for_student(self.student.id).empty? # нет упоминаний о студенте
      result = result || (self.class.approved.for_student(self.student.id).empty? && self.class.awaiting_approval.for_student(self.student.id).empty? && self.project.active? )# или студент не утвержден в активном проекте
    else
      true
    end
  end

  # суммы для индивидуальных задач
  def issues_planned_summ_grade
    Participant.sum("issues.planned_grade", :include => :issues, :conditions => {'participants.id' => self.id})
  end

  def issues_fact_summ_grade
    Participant.sum("issues.grade", :include => :issues, :conditions => {'participants.id' => self.id})
  end


  # Для семестровой суммы баллов
  def visitation_total_summ_rate
    Visitation.sum(:rate, :conditions => ['participant_id = ?', self.id])
  end

  def total_term_mark
    self.visitation_total_summ_rate.to_f +
    Issue.sum(:grade, :conditions => ['participant_id = ? AND closed_at >= ?', self.id, Gpoday.find(:first, :order => "date").date]).to_f
  end

end

