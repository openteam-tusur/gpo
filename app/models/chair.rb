class Chair < ActiveRecord::Base
  attr_accessible :title, :abbr, :chief, :contingent_abbr, :faculty

  require 'translit'

  validates_presence_of :title, :abbr, :chief
  validates_uniqueness_of :abbr

  has_many :projects, -> { order('cipher desc') }, :dependent => :destroy
  has_many :orders, -> { order('id desc') }, :dependent => :destroy
  has_many :workgroup_orders, -> { order('id desc') }, :dependent => :destroy
  has_many :opening_orders, -> { order('id desc') }, :dependent => :destroy
  has_many :people, -> { order('last_name') }, :dependent => :destroy
  has_many :participants, -> { order('last_name') }, :through => :projects
  has_many :activities, -> { order('created_at desc').limit(10) }, :dependent => :destroy
  has_many :project_managers, -> { where(:state => :approved) }, :through => :projects
  has_one :last_activity, -> { order('created_at') }, :class_name => 'Activity'

  has_many :project_manager_users, :through => :project_managers, :source => :person
  has_many :permissions, :as => :context, :dependent => :destroy
  has_many :mentors, -> { where('permissions.role = ?' => 'mentor').order('last_name') }, :through => :permissions, :source => :user

  scope :ordered_by_abbr, -> { order 'abbr' }
  scope :ordered_by_title, -> { order 'title' }
  scope :ordered_by_faculty, -> { order 'faculty, title' }

  def mentors
    permissions.for_role(:mentor).map(&:user).compact.sort_by(&:surname)
  end

  def uniq_project_manager_users
    self.project_manager_users.uniq
  end

  def id_to_s
    self.abbr
  end

  def stats(*types)
    Stat.for_chair(self, *types)
  end

  def tasks(user, context = nil)
    TaskManager.tasks_for(user, self, context)
  end

  def xml_for_chair_statement_checkup
    self.to_xml(:skip_types => true, :root => "doc") do |xml|
      xml.stage_title_last ReportingStage.descending.first.title
      xml.stage_title_previous ReportingStage.descending.second.title
      xml.stage_count_last ReportingStage.descending.first.stages.joins(:project).where(projects: {chair_id: self.id}).unfilled.count
      xml.stage_count_previous ReportingStage.descending.second.stages.joins(:project).where(projects: {chair_id: self.id}).unfilled.count
      xml.chair_abbr self.abbr
      xml.faculty_abbr self.faculty_abbr
      xml.chair_chief name_abbr(self.chief.split(' '))
      xml.count_participants self.participants.active.count
      xml.count_participants_2_4 self.participants.active.at_course(2).count + self.participants.active.at_course(3).count + self.participants.active.at_course(4).count
      xml.count_participants_2 self.participants.active.at_course(2).count
      xml.count_participants_3 self.participants.active.at_course(3).count
      xml.count_participants_4 self.participants.active.at_course(4).count
      xml.count_project_managers uniq_project_manager_users.count
      xml.count_projects self.projects.current_active.count
      xml.count_sbi_projects self.projects.active.with_participants.sbi_residents.count
      # xml.spring_stages attestation_stages(self.projects.current_active, 'Промежуточная аттестация за весенний')
      # xml.autumn_stages attestation_stages(self.projects.current_active, 'Промежуточная аттестация за осенний')
      xml.mentor name_abbr([self.mentors.first.surname, self.mentors.first.name, self.mentors.first.patronymic])
      xml.projects do |xml_project|
        self.projects.current_active.each do |project|
          xml.project do
            xml.cipher project.cipher
            xml.auditorium project.auditorium
            xml.project_managers project.project_managers.active.active.map(&:person).join(', ')
            xml.count_participants_2_4 project.participants.active.at_course(2).count + project.participants.active.at_course(3).count + project.participants.active.at_course(4).count
            xml.count_participants_2 project.participants.active.at_course(2).count
            xml.count_participants_3 project.participants.active.at_course(3).count
            xml.count_participants_4 project.participants.active.at_course(4).count
          end
        end
      end
      xml.project_managers do |xml_project_manager|
        uniq_project_manager_users.each do |user|
          xml.project_manager do
            xml.name user
          end
        end
      end
    end
  end

  def faculty_abbr
    begin
      match_data = faculty.to_s.match(/\((.+)\)/)
      match_data ? match_data[1] : ""
    rescue
      ""
    end
  end

  def transliterated_faculty_abbr
    Translit.convert(faculty_abbr, :english).downcase()
  end

  def name_abbr (name)
    name_abbr = ''
    name_abbr += name[1][0] + '. ' if name[1].present?
    name_abbr += name[2][0] + '. ' if name[2].present?
    name_abbr += name[0]
  end

# not working stages counter
  def attestation_stages (projects, title)
    stages_count = 0
    projects.map(&:stages).flatten.each do |stage|
      start_year, end_year = stage.current_period_years
      if (stage.title.include? title) && (Time.zone.now.year == end_year)#(DateTime.now.to_date > stage.start)
        stages_count += 1
      end
    end
    stages_count
  end


end

# == Schema Information
#
# Table name: chairs
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  abbr            :string(255)
#  chief           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  faculty         :string(255)
#  contingent_abbr :string(255)
#
