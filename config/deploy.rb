require "bundler/capistrano"
require "rvm/capistrano"

load "config/deploy/settings"
load "config/deploy/assets"
load "config/deploy/tag"
load "config/deploy/caprake"

namespace :deploy do
  desc "Copy config files"
  task :config_app, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Reload Unicorn"
  task :reload_servers do
    sudo "/etc/init.d/#{unicorn_instance_name} restart"
  end

  desc "Update crontab tasks"
  task :crontab do
    run "cd #{deploy_to}/current && exec bundle exec whenever --update-crontab --load-file #{deploy_to}/current/config/schedule.rb"
  end

  desc "Airbrake notify"
  task :airbrake do
    run "cd #{deploy_to}/current && RAILS_ENV=production TO=production bin/rake airbrake:deploy"
  end

  desc 'Load data from old system'
  task :load_old_data do
    sudo "/etc/init.d/#{unicorn_instance_name} stop"
    run "rm #{deploy_to}/current/bin/sync #{deploy_to}/current/public/files"
    run "ln -s #{deploy_to}/shared/bin/sync #{deploy_to}/current/bin/sync"
    run "ln -s #{deploy_to}/shared/public/files #{deploy_to}/current/public/files"
    run "cd #{deploy_to}/current && bin/sync"
    run "cd #{deploy_to}/current && bin/rake db:migrate RAILS_ENV=production"
    sudo "/etc/init.d/#{unicorn_instance_name} start"
  end
end

# deploy
after "deploy:finalize_update", "deploy:config_app"
after "deploy", "deploy:migrate"
after "deploy", "deploy:reload_servers"
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:crontab"
after "deploy", "deploy:airbrake"

# deploy:rollback
after "deploy:rollback", "deploy:reload_servers"
