require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Quamundo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Split locales files over a direcotry tree
    # look at: https://guides.rubyonrails.org/i18n.html#organization-of-locale-files
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    # PostgreSQL is used with special features (views etc.),
    # so use `structure.sql`
    config.active_record.schema_format = :sql

    # Use vips for image processing
    # config.active_storage.variant_processor = :vips

    # quamundo version
    config.quamundo_version = `git describe --tags --first-parent`.gsub(/^release.?\//, '')
  end
end
