class Exporter::ChairProjectsWithManagers
  def to_csv
    CSV.open('chair_projects_with_managers.csv', 'wb', col_sep: ';') do |csv|
      csv << ['Кафедра', 'Название проекта', 'Руководители проекта']
      active_projects.each do |project|
        csv << [project.chair_abbr, project.title, project_managers(project)]
      end
    end
  end

  def project_managers(project)
    project.project_managers.map(&:to_s).join(', ')
  end

  def active_projects
    Project.includes(:chair).active.order('chairs.abbr')
  end
end
