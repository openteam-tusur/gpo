require 'openteam/capistrano/deploy'

append :linked_dirs, 'system'

desc 'Download files'
task :download_files do
  on roles(:all) do |host|
    download! "#{shared_path}/system", '.', via: :scp, recursive: :true
  end
end


set :slackistrano,
  channel: (Settings['slack.channel'] rescue ''),
  webhook: (Settings['slack.webhook'] rescue '')
