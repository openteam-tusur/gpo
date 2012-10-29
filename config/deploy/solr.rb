settings_yml_path = "config/settings.yml"
config = YAML::load(File.open(settings_yml_path))
raise "not found deploy key in settings.yml. see settings.yml.example" unless config['deploy']
solr_domain = config['deploy']["solr_domain"]
raise "not found deploy.solr_domain key in settings.yml. see settings.yml.example" unless solr_domain
solr_port = config['deploy']["solr_port"]
raise "not found deploy.solr_port key in settings.yml. see settings.yml.example" unless solr_port

namespace :solr do
  desc "Upload local solr config to remote server"
  task :export do
    run_locally("scp -r -P #{solr_port} solr/conf/ #{solr_domain}:/var/lib/tomcat6/solr/")
    run_locally("scp -r -P #{solr_port} solr/lib/ #{solr_domain}:/var/lib/tomcat6/solr/")
    run_locally("ssh #{solr_domain} -p #{solr_port} chown -R tomcat6:tomcat6 /var/lib/tomcat6/solr/")
  end

  desc "Restart Tomcat6/Solr server"
  task :restart do
    run_locally("ssh #{solr_domain} -p #{solr_port} /etc/init.d/tomcat6 restart")
  end

  desc "Download remote solr config"
  task :import do
    run_locally("scp -r -P #{solr_port} #{solr_domain}:/var/lib/tomcat6/solr/conf/ solr/")
  end
end
