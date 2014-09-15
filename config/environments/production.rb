Gpo::Application.configure do
  config.cache_classes                     = true
  config.eager_load                        = true
  config.consider_all_request_local        = false
  config.action_controller.perform_caching = true
  config.serve_static_assets               = false
  config.assets.compile                    = false
  config.assets.digest                     = true
  config.assets.version                    = '1.0'
  config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'
  config.log_level                         = :info
  config.i18n.fallbacks                    = true
  config.active_support.deprecation        = :notify
  config.log_formatter                     = ::Logger::Formatter.new
  config.assets.precompile                 += %w(print.css browsing.js)
  config.assets.js_compressor              = :uglifier
end
