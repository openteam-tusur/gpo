Factory.define :issue, :default_strategy => :attributes_for do | issue |
  issue.association :participant, :factory => :participant
  issue.name "Задача"
  issue.description  "Содержание работ"
  issue.planned_closing_at Date.today
  issue.planned_grade 1
  issue.closed_at Date.today
  issue.grade 1
  issue.results "Полученные результы"
end

