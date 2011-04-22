class Participant < ActiveRecord::Base
  has_states :awaiting_approval, :approved, :awaiting_removal, :removed do
    on :approve do
      transition :awaiting_approval => :approved, :awaiting_removal => :removed
    end
    on :cancel do
      transition :awaiting_approval => :removed, :awaiting_removal => :approved
    end
    on :remove do
      transition :approved => :awaiting_removal
    end
  end

  validates_presence_of :student_id
  validates_presence_of :project_id

  belongs_to :student
  belongs_to :project
  belongs_to :chair
  has_many :visitations, :dependent => :destroy
  has_many :issues, :order => :planned_closing_at, :dependent => :destroy

  named_scope :active, :conditions => {:state => ['approved', 'awaiting_removal']}, :order => :last_name
  named_scope :at_course, lambda { |course| { :conditions => [ 'course = ?', course ] } }
  named_scope :awaiting, lambda { { :conditions => [ 'state = ? OR state = ?', 'awaiting_approval', 'awaiting_removal' ] } }
  named_scope :problematic, lambda { { :conditions =>  [ '((state = ? OR state = ?) AND contingent_gpo = ?) OR contingent_active =?',
       'approved', 'awaiting_removal', false, false], :order => "last_name" } }

  named_scope :for_student, lambda { |id| { :conditions => { :student_id => id } } }

  def state_description
    L10N[:participant]["state_#{self.state}"]
  end

  def name
    "#{self.last_name} #{self.first_name} #{self.mid_name}"
  end

  def problems
    returning Array.new do | problems |
      problems << %q(Не числится учащимся в АИС "Контингент") unless contingent_active?
      problems << %q(Не числится в ГПО в АИС "Контингент") if (approved? || awaiting_removal?) && !contingent_gpo?
    end
  end

  def before_create
    self.update_from_contingent
  end

  def update_from_contingent
    self.first_name = self.student.first_name
    self.mid_name = self.student.mid_name
    self.last_name = self.student.last_name
    self.chair_abbr = self.student.chair_abbr
    self.edu_group = self.student.edu_group
    self.course = self.student.course
    self.contingent_active = self.student.active
    self.contingent_gpo = self.student.gpo
    self.chair_id = self.project.chair_id
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

  def after_enter_removed
    self.destroy
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

