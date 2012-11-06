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
#  first_name        :string(255)
#  mid_name          :string(255)
#  last_name         :string(255)
#  edu_group         :string(255)
#  contingent_active :boolean
#  contingent_gpo    :boolean
#

class Participant < ActiveRecord::Base
  attr_accessible :first_name, :mid_name, :last_name, :edu_group, :course, :contingent_active, :contingent_gpo, :student_id
  attr_accessible :state_event
  belongs_to :project

  has_one :chair,  :through => :project
  has_many :visitations,  :dependent => :destroy
  has_many :issues,       :order => :planned_closing_at,                                         :dependent => :destroy

  validates_presence_of :student_id
  validates_presence_of :project_id
  validates_uniqueness_of :student_id

  scope :ordered,            order(:last_name)
  scope :active,             where(:state => %w[approved awaiting_removal]).ordered
  scope :awaiting,           where(:state => %w[awaiting_approval awaiting_removal])
  scope :awaiting_approval,  where(:state => 'awaiting_approval')
  scope :awaiting_removal,   where(:state => 'awaiting_removal')
  scope :problematic,        where('(state in (?) AND contingent_gpo = ?) OR contingent_active = ?', %w[approved awaiting_removal], false, false).ordered
  scope :at_course,          ->(course) { where(:course => course) }
  scope :for_student,        ->(id)     { where(:student_id => id) }

  delegate :abbr, :to => :chair, :prefix => true

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
    after_transition all => :removed do |participant|
      participant.destroy
    end
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

  def self.contingent_find(params)
    url = "#{Settings['students.url']}?format=json&lastname=#{params[:lastname]}&group=#{params[:group]}"
    JSON.parse(Curl.get(url).body_str).map do |attributes|
      attributes.symbolize_keys!
      Participant.find_or_initialize_by_student_id(attributes[:study_id]) do |participant|
        participant.first_name        = attributes[:firstname]
        participant.mid_name          = attributes[:patronymic]
        participant.last_name         = attributes[:lastname]
        participant.edu_group         = attributes[:group]
        participant.course            = attributes[:year]
        participant.contingent_active = attributes[:learns]
        participant.contingent_gpo    = attributes[:in_gpo]
      end
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
    Participant.joins(:issues).where('participants.id' => self.id).sum('issues.planned_grade')
  end

  def issues_fact_summ_grade
    Participant.joins(:issues).where('participants.id' => self.id).sum('issues.grade')
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

