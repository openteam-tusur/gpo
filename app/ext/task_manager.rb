# encoding: utf-8

class TaskManager
  attr_accessor :date, :category, :description, :priority

  def initialize(description)
    @description = description
    @date = date || Time.now
    @priority = 3
    @category = nil
  end

  def self.tasks_for(person, chair, context = nil)
    ret = []
    if person.manager?
      ret = manager_tasks(chair, context)
    elsif person.mentor_of?(chair)
      ret = mentor_tasks(chair)
    elsif person.managable_projects.select{|p| p.chair == chair}.any?
      ret = problematic_participants_tasks(person.managable_projects)
      ret += project_visitations_task(person.managable_projects)
    end
    ret
  end

  def self.manager_tasks(chair, context = nil)
    ret = []
    chair.orders.blocking.each do | order |
      ret << OrderTaskManager.new(order)
    end
    ret += problematic_participants_tasks(chair.projects.active+chair.projects.draft)
    ret += project_visitations_task(chair.projects.active) if context != "dashboard"
    ret
  end

  def self.mentor_tasks(chair)
    ret = []
    chair.orders.draft.each do | order |
      ret << OrderTaskManager.new(order)
    end
    ret += problematic_participants_tasks(chair.projects.active+chair.projects.draft)
    ret += project_visitations_task(chair.projects.active)
  end

  def self.problematic_participants_tasks(projects)
    ret = []
    projects.each do | project |
      ret << ProblematicParticipantsTaskManager.new(project) unless project.participants.problematic.empty?
    end
    ret
  end

  def self.project_visitations_task(projects)
    ret = []
    projects.each do | project |
      ret << ProjectVisitationsTaskManager.new(project) if project.visitations_problem?
    end
    ret
  end
end

class OrderTaskManager < TaskManager
  attr_reader :order

  def initialize(order)
    @order = order
    @category = "order"
    @date = order.updated_at

    case order.state
    when "draft"
      action = "Отправить на визирование"
      @priority = 1
    when "reviewed"
      action = "Утвердить"
      @priority = 1
    when "being_reviewed"
      action = "Визировать"
      @priority = 2
    else
      raise
    end
    @description = "#{action} приказ #{order.title} #{order.projects_to_s}"
  end
end

class ProblematicParticipantsTaskManager < TaskManager
  attr_reader :project

  def initialize(project)
    @date = 1.day.ago
    @project = project
    @category = "project"

    count = project.participants.problematic.count
    @description = "В проекте #{project.cipher} есть #{count} #{Participant.pluralized_string(count)} с неправильным статусом"
  end
end

class ProjectVisitationsTaskManager < TaskManager
  attr_reader :project

  def initialize(project)
    @date = 1.day.ago
    @project = project
    @category = "project"

    @description = "В проекте #{project.cipher} есть незаполненные данные по посещаемости"
  end
end

