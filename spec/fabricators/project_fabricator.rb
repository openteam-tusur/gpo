Fabricator(:project) do
  chair
  cipher 'Project chiper'
  title 'Project title'

  after_create { |project| project.participants << Fabricate.build(:participant) }
end
