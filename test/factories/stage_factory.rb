Factory.define :stage do |stage|
  stage.project_id { |project| project.association(:project).id }
  stage.title 'Термоядерная установка'
  stage.start '01.01.2008'
  stage.finish '01.01.2008'
end
