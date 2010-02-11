require 'yaml'

L10N = YAML.load_file("#{RAILS_ROOT}/config/localization.yml").with_indifferent_access
