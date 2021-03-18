desc 'Обновление связей руководителей проектов и директори'
task update_pm_on_directory: :environment do
  project_managers = ProjectManager.all.active
  pb = ProgressBar.new(project_managers.count)
  project_managers.each do |pm|
    params = {
      user_id: pm.person.user_id,
      personal_data: {
        surname: pm.person.last_name,
        name: pm.person.first_name,
        patronymic: pm.person.middle_name
      }
    }
    directory_url = "#{Settings['directory.url']}/api/v2/persons/is_exist"
    response = JSON.parse(RestClient::Request.execute(method: :post, url: directory_url, headers: { params: { data: params } }))
    if response['response']
      ProjectManager.find(pm.id).update_attribute(:directory_id, response['id'])
    end
    pb.increment!
  end
end
