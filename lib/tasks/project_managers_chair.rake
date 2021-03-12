require 'progress_bar'

desc 'compare from chair of project managers with directory'
task :project_managers_chair => :environment do
  pb = ProgressBar.new(ProjectManager.all.count)
  ProjectManager.all.map do |manager|
    params = {
      user_id: manager.person.user_id,
      personal_data: {
        surname: manager.person.last_name,
        name: manager.person.first_name,
        patronymic: manager.person.middle_name
      },
      chair_abbr: manager.person.chair.abbr
    }
    directory_url = "#{Settings['directory.url']}/api/v2/persons/from_chair"
    response = JSON.parse(RestClient::Request.execute( method: :post, url: directory_url, headers: { params: {data: params }}))
    if response['from_chair'] == 'yes'
      manager.update_attribute(:from_chair, 'true')
    end
    pb.increment!
  end
end
