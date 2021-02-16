desc 'Руководители проектов и их группы'
require 'csv'
task project_managers_and_groups: :environment do
  file = "#{Rails.root}/public/project_managers_and_groups.csv"
  headers = ["Кафедра", "Руководитель", "Группы"]
  CSV.open(file, "w", write_headers: true, headers: headers) do |writer|
    Chair.all.each do |chair|
      writer << ["#{chair.title} (#{chair.abbr})", "", "", ""]
      chair.projects.each do |project|
        project.project_managers.each do |pm|
          writer << ["",
                     pm.fullname,
                     Participant.for_project_manager(pm.id).pluck(:edu_group).uniq.join(", ") ]
        end
      end
    end
  end
end

