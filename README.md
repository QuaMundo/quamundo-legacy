# README

## Installation

First run `bundle install --without developmen test`.

Create database with `bin/rails db:setup RAILS_ENV=production`.

Ensure there's a default admin user with id of 0: `bin/rails user:initial_admin_user` (This user should have been created by `bin/rails db:setup`, but if you have an older version of quamundo installed, this will ensure existence of user 0).

Install javascript and css packages:

~~~shell
yarn install
bin/rails webpacker:compile
bin/rails assets:precompile
~~~

## Development

In development (and test) environment, best aproach is to use docker with a postgresql image. It can be started by `foreman start` - which also starts werbpack-dev-server and a rails server.

To use/test email, the mail config for development and test environment makes use of gem 'mailcatcher' which is recommended to be installed and started manually (see [mailcatcher docs](https://github.com/sj26/mailcatcher#mailcatcher)).

~~~shell
gem install mailcatcher
mailcatcher
~~~

//FIXME: This was default stuff
This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
