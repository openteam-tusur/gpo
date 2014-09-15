Gpo::Application.configure do
  config.cache_classes                     =false
  config.eager_load                        =false
  config.consider_all_requests_local       =true
  config.action_controller.perform_caching =false
  config.active_support.deprecation        =:log
  config.active_record.migration_error     =:page_load
  config.assets.debug                      =false
  config.assets.log                        =false

  config.to_prepare do
    %w[ext].each do |dir|
      Dir[Rails.root.join("app/models/#{dir}/*")].each do |model_path|
        require_or_load model_path.to_s
      end
    end
  end
end
