Fabricator(:project) do
  chair
  cipher 'Project chiper'
  title 'Project title'

  after_create { |project| project.participants << Fabricate.build(:participant) }
  after_create { |project| Fabricate(:manager, project: project) }
end
