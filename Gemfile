source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0'
# Use webpack
gem 'webpacker'
# Use postgresql as the database for Active Record
gem 'pg'
# Use PostGIS extension
gem 'activerecord-postgis-adapter'
# Use Puma as the app server
gem 'puma'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# Use devise for authentication
gem 'devise'
gem 'devise-i18n'
# Use ActionPolicy  for authorization
gem 'action_policy'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# FIXME: After upgrade of Debian servers remove this entry!
# bcrypt 3.1.13 (the actual) doesn't run on raspi/Debian Stretch
  gem 'bcrypt', '<= 3.1.12'

# Use ActiveStorage variant
gem 'image_processing', '~> 1.2'

# Use Redcarpet to rener Markdown
gem 'redcarpet'

gem 'rails-i18n'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Use foreman to setup development environment
  gem 'foreman'
  # Selenium driver for accetpance testing
  gem 'selenium-webdriver'
  gem 'capybara'
  gem 'webmock'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'simplecov'
  gem 'rails-controller-testing'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console'
  gem 'ffi'
  gem 'listen'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'pry-stack_explorer'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
