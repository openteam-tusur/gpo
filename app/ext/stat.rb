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
    returning Array.new do |stats|
      types.each {|type| stats.concat collection.fetch(type) }
    end
  end

  def self.global(*types)
    stats_collection = {
      :projects => [
        Stat.new(:active_projects, Project.active.count, "Активных проектов"),
        Stat.new(:draft_projects, Project.draft.count, "Черновиков проектов"),
        Stat.new(:closed_projects, Project.closed.count, "Закрытых проектов")
      ],
      :participants => [
        Stat.new(:participant_total, Participant.active.count, "Всего студентов"),
        Stat.new(:participant_course_1, Participant.active.at_course(1).count, "Студентов 1 курса"),
        Stat.new(:participant_course_2, Participant.active.at_course(2).count, "Студентов 2 курса"),
        Stat.new(:participant_course_3, Participant.active.at_course(3).count, "Студентов 3 курса"),
        Stat.new(:participant_course_4, Participant.active.at_course(4).count, "Студентов 4 курса"),
        Stat.new(:participant_course_5, Participant.active.at_course(5).count, "Студентов 5 курса"),
        Stat.new(:participant_course_6, Participant.active.at_course(6).count, "Студентов 6 курса")
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

  def self.for_chair(chair, *types)
     stats_collection = {
      :projects => [
        Stat.new(:active_projects, chair.projects.active.count, "Активных проектов"),
        Stat.new(:draft_projects, chair.projects.draft.count, "Черновиков проектов"),
        Stat.new(:closed_projects, chair.projects.closed.count, "Закрытых проектов")
      ],
      :participants => [
        Stat.new(:participant_total, chair.participants.active.count, "Всего студентов"),
        Stat.new(:participant_course_1, chair.participants.active.at_course(1).count, "Студентов 1 курса"),
        Stat.new(:participant_course_2, chair.participants.active.at_course(2).count, "Студентов 2 курса"),
        Stat.new(:participant_course_3, chair.participants.active.at_course(3).count, "Студентов 3 курса"),
        Stat.new(:participant_course_4, chair.participants.active.at_course(4).count, "Студентов 4 курса"),
        Stat.new(:participant_course_5, chair.participants.active.at_course(5).count, "Студентов 5 курса"),
        Stat.new(:participant_course_6, chair.participants.active.at_course(6).count, "Студентов 6 курса")
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

  def self.for_project(project, *types)
    stats_collection = {
      :general => [
      ],
      :participants => [
        Stat.new(:participant_total, project.participants.active.count, "Всего студентов"),
        Stat.new(:participant_course_1, project.participants.active.at_course(1).count, "Студентов 1 курса"),
        Stat.new(:participant_course_2, project.participants.active.at_course(2).count, "Студентов 2 курса"),
        Stat.new(:participant_course_3, project.participants.active.at_course(3).count, "Студентов 3 курса"),
        Stat.new(:participant_course_4, project.participants.active.at_course(4).count, "Студентов 4 курса"),
        Stat.new(:participant_course_5, project.participants.active.at_course(5).count, "Студентов 5 курса"),
        Stat.new(:participant_course_6, project.participants.active.at_course(6).count, "Студентов 6 курса")
      ]
    }
    Stat.get_stats(stats_collection, *types)
  end

end
