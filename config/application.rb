require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Blacklight
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]

    I18n.available_locales = ["en", "nl", "en-US"]
    config.i18n.default_locale = :nl
    config.i18n.locale = :nl
    config.available_locales = %w(en nl)

    config.exceptions_app = self.routes
  end
end
