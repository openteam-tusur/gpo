# encoding: utf-8

class Task
  attr_accessor :date, :category, :description, :priority

  def initialize(description)
    @description = description
    @date = date || Time.now
    @priority = 3
    @category = nil
  end

  def self.tasks_for(user, chair, context = nil)
    ret = []
    if user.admin? || user.supervisor?
      ret = admin_tasks(chair, context)
    end
    if user.mentor_of?(chair)
      ret = mentor_tasks(chair)
    end
    if user.project_manager_of?(chair) && !user.mentor_of?(chair)
      ret = problematic_participants_tasks(user.managable_projects)
      ret += project_visitations_task(user.managable_projects)
    end
    ret
  end

  def self.admin_tasks(chair, context = nil)
    ret = []
    chair.orders.blocking.each do | order |
      ret << OrderTask.new(order)
    end
    ret += problematic_participants_tasks(chair.projects.active+chair.projects.draft)
    ret += project_visitations_task(chair.projects.active) if context != "dashboard"
    ret
  end

  def self.mentor_tasks(chair)
    ret = []
    chair.orders.draft.each do | order |
      ret << OrderTask.new(order)
    end
    ret += problematic_participants_tasks(chair.projects.active+chair.projects.draft)
    ret += project_visitations_task(chair.projects.active)
  end

  def self.problematic_participants_tasks(projects)
    ret = []
    projects.each do | project |
      ret << ProblematicParticipantsTask.new(project) unless project.participants.problematic.empty?
    end
    ret
  end

  def self.project_visitations_task(projects)
    ret = []
    projects.each do | project |
      ret << ProjectVisitationsTask.new(project) if project.visitations_problem?
    end
    ret
  end
end

class OrderTask < Task
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

class ProblematicParticipantsTask < Task
  attr_reader :project

  def initialize(project)
    @date = 1.day.ago
    @project = project
    @category = "project"

    count = project.participants.problematic.count
    @description = "В проекте #{project.cipher} есть #{count} #{Participant.pluralized_string(count)} с неправильным статусом"
  end
end

class ProjectVisitationsTask < Task
  attr_reader :project

  def initialize(project)
    @date = 1.day.ago
    @project = project
    @category = "project"

    @description = "В проекте #{project.cipher} есть незаполненные данные по посещаемости"
  end
end

