require File.expand_path('../boot', __FILE__)

require 'rails/all'

Bundler.require(:default, Rails.env)

module Gpo
  class Application < Rails::Application
    config.autoload_paths += %W(
      #{config.root}/lib/reports
      #{config.root}/lib/modules
    )

    config.time_zone = 'Novosibirsk'

    config.i18n.default_locale = :ru
  end
end
