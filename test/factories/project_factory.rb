Factory.define :project do |project|
  project.chair_id { |chair| chair.association(:chair).id }
  project.cipher 'АОИ-0701'
  project.title 'Термоядерная установка'
end
