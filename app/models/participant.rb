# encoding: utf-8
# == Schema Information
#
# Table name: participants
#
#  id                :integer          not null, primary key
#  student_id        :integer
#  state             :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  project_id        :integer
#  course            :integer
#  first_name        :string(255)
#  middle_name       :string(255)
#  last_name         :string(255)
#  edu_group         :string(255)
#  contingent_active :boolean
#  contingent_gpo    :boolean
#  undergraduate     :boolean
#  subfaculty        :string(255)
#  faculty           :string(255)
#  executive         :boolean          default(FALSE)
#

require 'open-uri'

class Participant < ActiveRecord::Base
  attr_accessible :contingent_active,
                  :contingent_gpo,
                  :course,
                  :edu_group,
                  :executive,
                  :first_name,
                  :last_name,
                  :middle_name,
                  :state_event,
                  :student_id,
                  :subfaculty,
                  :faculty

  belongs_to :project

  has_one :chair,  :through => :project
  has_many :visitations,  :dependent => :destroy
  has_many :issues,       :order => :planned_closing_at, :dependent => :destroy

  validates_presence_of :student_id
  validates_presence_of :project_id

  before_create :check_createable
  before_save :set_undergraduate

  scope :ordered,                    -> { order(:last_name) }
  scope :active,                     -> { where(:state => %w[approved awaiting_removal]).ordered }
  scope :awaiting,                   -> { where(:state => %w[awaiting_approval awaiting_removal]) }
  scope :awaiting_approval,          -> { where(:state => 'awaiting_approval') }
  scope :awaiting_removal,           -> { where(:state => 'awaiting_removal') }
  scope :problematic,                -> { where('(state in (?) AND contingent_gpo = ?) OR contingent_active = ?', %w[approved awaiting_removal], false, false).ordered }
  scope :at_course,                  ->(course) { where('course = ? AND undergraduate != true', course) }
  scope :for_student,                ->(id)     { where(:student_id => id) }
  scope :undergraduates,             -> { where(undergraduate: true) }
  scope :undergraduates_at_course,   ->(course) { where('course = ? AND undergraduate = true', course) }
  scope :as_executive,               -> { where(:executive => true) }
  scope :sbi_residents,              -> { joins(:project).where 'projects.sbi_placing' => :resident }
  scope :interfaculty,               -> { joins(:project).where 'projects.interdisciplinary' => :interfaculty }
  scope :intersubfaculty,            -> { joins(:project).where 'projects.interdisciplinary' => :intersubfaculty }

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

  def current_state
    if self.executive
      'ответственный исполнитель'
    else
      self.human_state_name
    end
  end

  def name
    "#{self.last_name} #{self.first_name} #{self.middle_name}".squish
  end

  def name_with_abbr
    name = "#{self.last_name} #{self.first_name[0]}."
    name += " #{self.middle_name[0]}." if self.middle_name.present?
    name.squish
  end

  def name_with_group
    name_with_group = name
    name_with_group += " (гр. #{edu_group})" if edu_group.present?
    name_with_group.squish
  end

  def problems
    [].tap do | problems |
      problems << %q(Не числится учащимся в АИС "Контингент") unless contingent_active?
      problems << %q(Не числится в ГПО в АИС "Контингент") if (approved? || awaiting_removal?) && !contingent_gpo?
    end
  end

  def self.contingent_find_for_manage(params)
    contingent_find(params[:search] || {}).map! do |participant|
      participant.project_id = params[:project_id] if participant.new_record?
      participant.awaiting_removal? ? participant.dup : participant
    end
  end

  def self.contingent_find(params)
    JSON.parse(self.contingent_response(params)).flat_map do |attributes|
      attributes.symbolize_keys!
      participants = Participant.where(:student_id => attributes[:study_id]).all
      participants << Participant.new(:student_id => attributes[:study_id]) if participants.empty?
      participants.each do |participant|
        participant.first_name        = attributes[:firstname]
        participant.middle_name       = attributes[:patronymic]
        participant.last_name         = attributes[:lastname]
        participant.edu_group         = attributes[:group]['number']
        participant.course            = attributes[:group]['course']
        participant.contingent_active = attributes[:learns]
        participant.contingent_gpo    = attributes[:in_gpo]
        participant.subfaculty        = attributes[:education]['params']['sub_faculty']['short_name']
        participant.faculty           = attributes[:education]['params']['faculty']['short_name']
      end
    end
  end

  def visitation_for_gpoday(gpoday)
    self.visitations.find_or_create_by_gpoday_id(gpoday.id)
  end

  # для приказа
  def text_for_order_report
    "#{self.name}, гр. #{self.edu_group}, каф. #{self.subfaculty}"
  end

  def self.pluralized_string(count)
    Russian.p(count, 'участник', 'участника', 'участников')
  end

  def createable?(project = self.project)
    new_record? &&
      similar_participants.where(:state => [:approved, :awaiting_approval]).empty? &&
      similar_participants.where(:project_id => project.id).empty? &&
      ((project.draft? && awaiting_approval?) || (project.active?))
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

  private

  def similar_participants
    Participant.where(:student_id => student_id)
  end

  def self.contingent_response(params)
    open("#{Settings['students.url']}/api/v1/students?#{params.to_query}").read
  end

  def set_undergraduate
    self.undergraduate = !!(self.edu_group =~ /(m|м)/i)
    true
  end

  def check_createable
    raise "Cann't create participant" unless createable?
    true
  end
end
