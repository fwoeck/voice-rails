ENV['TZ'] = 'UTC'
require File.expand_path('../boot', __FILE__)

require 'yaml'
require 'json'
require 'base64'
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

WimVersion = `git tag | sort | tail -1`.strip
WimConfig  = YAML.load_file('./config/app.yml')

WimConfig.keys.each { |key|
  WimConfig.instance_eval "class << self; define_method(:#{key}) {self['#{key}']}; end"
}

module Voice
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Etc/UTC'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

    config.generators do |g|
      g.orm :active_record
    end

    config.cache_store = :memory_store
    config.action_dispatch.perform_deep_munge = false
  end
end
