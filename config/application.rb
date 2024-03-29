# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
# require 'action_mailbox/engine'
# require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
# require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Quamundo
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    # Split locales files over a direcotry tree
    # look at: https://guides.rubyonrails.org/i18n.html#organization-of-locale-files
    config.i18n.load_path += Dir[Rails.root.join('config/locales/**/*.{rb,yml}')]

    # PostgreSQL is used with special features (views etc.),
    # so use `structure.sql`
    config.active_record.schema_format = :sql

    # Use vips for image processing
    # config.active_storage.variant_processor = :vips

    # quamundo version
    config.quamundo_version = `git describe --tags --first-parent`.gsub(%r{^release.?/}, '')
  end
end
