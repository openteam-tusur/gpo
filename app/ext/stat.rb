# encoding: utf-8
class Stat
  attr_reader :title, :value, :key

  def initialize(key, value, title)
    @key = key
    @value = value
    @title = title
  end

  def self.get_stats(collection, *types)
    types = collection.keys if types.empty?
    [].tap do |stats|
      types.each {|type| stats.concat collection.fetch(type) }
    end
  end

  def self.global(*types)
    stats_collection = {
      :projects => [
        Stat.new(:active_projects,          Project.active.count,                  I18n.t('statistics.active_projects')),
        Stat.new(:sbi_projects,             Project.active.sbi_residents.count,    I18n.t('statistics.sbi_projects')),
        Stat.new(:interunivercity_projects, Project.active.interunivercity.count,  I18n.t('statistics.interunivercity_projects')),
        Stat.new(:interfaculty_projects,    Project.active.interfaculty.count,     I18n.t('statistics.interfaculty_projects')),
        Stat.new(:intersubfaculty_projects, Project.active.intersubfaculty.count,  I18n.t('statistics.intersubfaculty_projects')),
        Stat.new(:draft_projects,           Project.draft.count,                   I18n.t('statistics.draft_projects')),
        Stat.new(:closed_projects,          Project.closed.count,                  I18n.t('statistics.closed_projects'))
      ],
      :managers => [
        Stat.new(:managers, ProjectManager.approved.map(&:person).uniq.count, I18n.t('statistics.managers'))
      ],
      :participants => [
        Stat.new(:participant_total,            Participant.active.count,                       I18n.t('statistics.participant_total')),
        Stat.new(:participant_sbi,              Participant.active.sbi_residents.count,                I18n.t('statistics.participant_sbi')),
        Stat.new(:participant_intersubfaculty,  Project.intersubfaculty.map {|p| p.participants.active.count - p.participants.active.with_subfaculty(p.chair.contingent_abbr).count}.sum,              I18n.t('statistics.participant_intersubfaculty')),
        Stat.new(:participant_other_univercity, Participant.active.other_univercity.count,      I18n.t('statistics.participant_other_univercity')),
        Stat.new(:participant_course_1,         Participant.active.at_course(1).count,          I18n.t('statistics.participant_course_1')),
        Stat.new(:participant_course_2,         Participant.active.at_course(2).count,          I18n.t('statistics.participant_course_2')),
        Stat.new(:participant_course_3,         Participant.active.at_course(3).count,          I18n.t('statistics.participant_course_3')),
        Stat.new(:participant_course_4,         Participant.active.at_course(4).count,          I18n.t('statistics.participant_course_4')),
        Stat.new(:participant_course_5,         Participant.active.at_course(5).count,          I18n.t('statistics.participant_course_5')),
        Stat.new(:undergraduates_at_course_1,   Participant.undergraduates_at_course(1).count,  I18n.t('statistics.undergraduates_at_course_1')),
        Stat.new(:undergraduates_at_course_2,   Participant.undergraduates_at_course(2).count,  I18n.t('statistics.undergraduates_at_course_2'))
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

  def self.for_chair(chair, *types)
     stats_collection = {
      :projects => [
        Stat.new(:active_projects,          chair.projects.active.count,                   I18n.t('statistics.active_projects')),
        Stat.new(:interunivercity_projects, chair.projects.active.interunivercity.count,          I18n.t('statistics.interunivercity_projects')),
        Stat.new(:sbi_projects,             chair.projects.active.sbi_residents.count,     I18n.t('statistics.sbi_projects')),
        Stat.new(:interfaculty_projects,    chair.projects.active.interfaculty.count,      I18n.t('statistics.interfaculty_projects')),
        Stat.new(:intersubfaculty_projects, chair.projects.active.intersubfaculty.count,   I18n.t('statistics.intersubfaculty_projects')),
        Stat.new(:draft_projects,           chair.projects.draft.count,                    I18n.t('statistics.draft_projects')),
        Stat.new(:closed_projects,          chair.projects.closed.count,                   I18n.t('statistics.closed_projects'))
      ],
      :managers => [
        Stat.new(:managers, chair.project_managers.approved.map(&:person).uniq.count, I18n.t('statistics.managers'))
      ],
      :participants => [
        Stat.new(:participant_total,            chair.participants.active.count,                                I18n.t('statistics.participant_total')),
        Stat.new(:participant_sbi,              chair.participants.sbi_residents.count,                         I18n.t('statistics.participant_sbi')),
        #Stat.new(:participant_interfaculty,     chair.participants.interfaculty.count,                          I18n.t('statistics.participant_interfaculty')),
        Stat.new(:participant_intersubfaculty,  chair.participants.active.count - chair.participants.active.with_subfaculty(chair.contingent_abbr).count,         I18n.t('statistics.participant_intersubfaculty')),
        Stat.new(:participant_other_univercity, chair.participants.active.other_univercity.count,      I18n.t('statistics.participant_other_univercity')),
        Stat.new(:participant_course_1,         chair.participants.active.at_course(1).count,                   I18n.t('statistics.participant_course_1')),
        Stat.new(:participant_course_2,         chair.participants.active.at_course(2).count,                   I18n.t('statistics.participant_course_2')),
        Stat.new(:participant_course_3,         chair.participants.active.at_course(3).count,                   I18n.t('statistics.participant_course_3')),
        Stat.new(:participant_course_4,         chair.participants.active.at_course(4).count,                   I18n.t('statistics.participant_course_4')),
        Stat.new(:participant_course_5,         chair.participants.active.at_course(5).count,                   I18n.t('statistics.participant_course_5')),
        Stat.new(:undergraduates_at_course_1,   chair.participants.active.undergraduates_at_course(1).count,    I18n.t('statistics.undergraduates_at_course_1')),
        Stat.new(:undergraduates_at_course_2,   chair.participants.active.undergraduates_at_course(2).count,    I18n.t('statistics.undergraduates_at_course_2'))
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

  def self.for_project(project, *types)
    stats_collection = {
      :general => [
      ],
      :participants => [
        Stat.new(:participant_total,    project.participants.active.count,                                   I18n.t('statistics.participant_total')),
        Stat.new(:participant_intersubfaculty,  project.participants.active.count - project.participants.active.with_subfaculty(project.chair.abbr).count, I18n.t('statistics.participant_intersubfaculty')),
        Stat.new(:participant_course_1, project.participants.active.at_course(1).count,                      I18n.t('statistics.participant_course_1')),
        Stat.new(:participant_course_2, project.participants.active.at_course(2).count,                      I18n.t('statistics.participant_course_2')),
        Stat.new(:participant_course_3, project.participants.active.at_course(3).count,                      I18n.t('statistics.participant_course_3')),
        Stat.new(:participant_course_4, project.participants.active.at_course(4).count,                      I18n.t('statistics.participant_course_4')),
        Stat.new(:participant_course_5, project.participants.active.at_course(5).count,                      I18n.t('statistics.participant_course_5')),
        Stat.new(:undergraduates_at_course_1, project.participants.active.undergraduates_at_course(1).count, I18n.t('statistics.undergraduates_at_course_1')),
        Stat.new(:undergraduates_at_course_2, project.participants.active.undergraduates_at_course(2).count, I18n.t('statistics.undergraduates_at_course_2'))
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

end
