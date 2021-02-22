# README

**QuaMundo** is a web based app for building fictional or investigate in real
worlds by taking sort of "smart notes" – think of it as a
"multi-dimensional and multi-medial notebook".

QuaMundo is in an early stage of development, so many things aren't implemented
yet or don't work as expected – or may look "ugly". For details see section
"Roadmap"

QuaMundo is based on the [Ruby on Rails](https://rubyonrails.org/) Framework and
utilizes some javascript libraries (for example
[OpenLayers](https://openlayers.org/) and [D3](https://d3js.org/)) in the
frontend.

QuaMundo aims to be a useful set of tools for authors, historians, game
developers, but also, for journalists, investigators, travellers and students.

*QuaMundo is in early stage of development; the GUI is just a proof of concept in
order to be able to fill in data. It will be improved in the next preview
releases.*

## Overview

The basic concept of QuaMundo is a *World*. In a world you can create
*Inventories*, which can be *Figures*, *Items*, *Locations* or *Concepts* (for
intangible things).

These inventories can be linked together and time-framed by *Facts*, which in
turn allow to relate inventories to another.

The data collected this way can then be searched and filtered (in future
versions) and visualized, for example by timelines or map views.

Further details can be found [here](https://doc.quamundo.de) (only in German
yet).

## Features

* Creating worlds
* Simple user and user-rights management
* Collecting inventories
* Link together inventories by "Facts"
* Create relations between inventories through facts by "Relations"
* Add tags, attributes and dossiers (including media data) to objects
* View maps and timelines (WIP)

### … not implemented yet

* Search data by inventories, time ranges, relations, tags, attributes, geo
  coordinates or full-text search
* Save a search as a filter
* Compile facts to *Episodes*
* Utilize a clipboard to focus work on specific objects

## Installation

### On premise

#### Requirements

Following packages are supposed to be present:

* [git](https://git-scm.com/)
* [ruby](https://www.ruby-lang.org/) (version >= 3.0),
  [bundler](https://bundler.io/),
* [nodejs](https://nodejs.org/), [yarn](https://yarnpkg.com/),
  [webpack](https://webpack.js.org/)
* [PostgreSQL](https://www.postgresql.org/) (version >=12) and
  [PostGIS](https://postgis.net/) extension (version >= 3.0)

#### Get the files

To install QuaMundo, run the following steps in a shell/terminal:

~~~shell
# clone the git repository
git clone https://github.com/QuaMundo/quamundo

# install gems and js packages
cd quamundo
bundle install
yarn install
~~~

#### Create and configure database and extensions

QuaMundo depends on PostgreSQL (and PostGIS extension). Installing and
configuring PostgreSQL is not covered by this README. Steps for creating a user
etc. is based on a Debian (10) system, so your mileage may vary.

As user 'postgres' create a database user:

~~~shell
# create user (and enter password)
sudo -u postgres createuser -Pds quamundo
~~~

*Attention! This user will have superuser privileges which is neccessary to
install the PostGIS extension! This will be revoked in a later step.*

The following instructions assume your database runs on the same host as your
rails app (i.e. localhost). For different settings visit the documentation of
your OS and the [PostgreSQL documentation](https://www.postgresql.org/docs/).

#### Configure app

For the time being QuaMundo is configured by environment variables, located in
file *.env.sh*. You are encouraged to use a local configuration file (i.e.
`.env.local`) for customized setup:

~~~shell
cp .env.local.sample .env.local
$EDITOR .env.local
~~~

Find following lines and change them according to your settings:

Change: `# export RAILS_ENV=production` to: `export RAILS_ENV=production`

Change: `export POSTGRES_PASSWORD_PRODUCTION=$POSTGRES_PASSWORD_PRODUCTION` to:
`export POSTGRES_PASSWORD_PRODUCTION='<the password you enterd above>'`

Change: `export POSTGRES_USER_PRODUCTION=$POSTGRES_USER_PRODUCTION` to: `export
POSTGRES_USER_PRODUCTION='quamundo'`

Change: `export POSTGRES_PORT_PRODUCTION=$POSTGRES_PORT_PRODUCTION` to: `export
POSTGRES_PORT_PRODUCTION=5432`

Also change all the `SMTP_*` and `MAIL_*` settings if you want to use the
reset-passwort functionality.

*(Configuration will be simplified in upcoming versions)*

After you customized your configuration set the environment by executing:

~~~shell
source .env.sh
~~~

#### Configuring maptile server

To configure map services create a configuration file via:

~~~shell
cp config/maptile_server.yml.sample config/maptile_server.yml
~~~

*(The rails app won't start without this file!)*

If you want to use map services, edit the file and set the url template for a
maptiler server according to the [OpenLayers
documentation](https://openlayers.org/en/latest/apidoc/module-ol_source_OSM-OSM.html)
As stated there:

> URL template. Must include {x}, {y} or {-y}, and {z} placeholders.

#### Set up rails server

To setup the rails app run following commands:

~~~shell
# create credentials (invokes editor)
rails credentials:edit

# create and setup database
rails db:setup

# compile assets, styles and javascripts
rails webpacker:compile
~~~

For security considerations revoke database access privileges which are no
longer used from db user:

~~~shell
sudo -u postgres psql --command='ALTER ROLE quamundo WITH NOSUPERUSER NOCREATEDB NOCREATEROLE;' quamundo
~~~

#### Starting the rails app

The rails app is served by [puma](https://puma.io/) which is configured to
listen on an unix domain socket (located in `tmp/puma.sock`). This setup is
aimed to be used in conjunction with a reverse proxy (like
[nginx](https://nginx.org/) for example).
Configuring a reverse proxy is not covered by this README.

To start the rails app on an unix domain socket simply call `rails s`

Alternatively you can start QuaMundo by binding the app on a tcp socket by:

~~~shell
puma -b tcp://0.0.0.0:8080
~~~

This way the app will listen on all network interfaces on port 8080.

However, the recommended way is to serve the app through a reverse proxy.

#### First login

The execution of `rails db:setup` will have created an initial admin user with
email 'example@example.tld' and password 'Qu4Mund0'. It is **highly recommended
to change password** and set the email address to your own address.

To open the app visit *http://localhost:8080* (or whichever your configuration
is like) and choose menu 'Login'. After login go to menu 'admin>profile' and
change your password.

Only admin users can create other users (and grant admin privilege to them).
However, admins can create worlds as well as regular users, so it's up to you,
if you use an admin account for regular work in QuaMundo, or if you use them for
administrative purposes only.

To create users, visit menu 'admin>Users'.

*Hint: For German translation add '?l=de' after the url in the address field of
your browser.*

### Via container

*ToDo*

## Roadmap

### Done yet:

* Create data structures, models and controllers
* Build a "proof of concept" UI (needs to be refactored for real use)
* Implement some prototype of data visualizations (maps, timelines - also just POC)

### ToDo:

… in random order …

* Rework UI/UX
* Create documentation
* Add Search and Filters
* Add import and export facilities
* Implement an API
* Provide docker/docker-compose container for local installation/use
* Transform to a *progressive web app* for offline-use
* Create tutorials, maybe a book

## Development

QuaMundo depends on a [PostgreSQL](https://www.postgresql.org/) database with
[PostGIS](https://postgis.net/) extension. For development a
docker/docker-compose file is included.

### Requirements

Following tools are supposed to be present:

* [git](https://git-scm.com/)
* [ruby](https://www.ruby-lang.org/), [bundler](https://bundler.io/),
  [foreman](https://github.com/ddollar/foreman)
* [nodejs](https://nodejs.org/), [yarn](https://yarnpkg.com/),
  [webpack](https://webpack.js.org/)
* [docker](https://www.docker.com/),
  [docker-compose](https://github.com/docker/compose)
* [chrome](https://www.google.com/chrome/),
  [chrome-driver](https://chromedriver.chromium.org/)

*(For required ruby version look at file `.ruby_version`).*

### Setup development environment

For using docker, make sure docker is allowed to create folders in your install
directory.

To prepare for development execute following steps in a shell/terminal:

~~~shell
# clone git repository
git clone https://github.com/QuaMundo/quamundo.git
cd quamundo

# optionally switch to desired version
git switch <branch>

# build container
docker-compose build

# setup shell environment
cp .env.local.sample .env.local; $EDITOR .env.local

# create maptile server configuration
# for development just copy sample file
cp config/maptile_server.yml.sample config/maptile_server.yml

# source environment
source .env.sh

# install ruby gems and js packages
bundle install
yarn install

# start rails server, webpack-dev-server and postgres
foreman start   # this may take a few minutes

# prepare database
rails db:setup

# run test suite
rspec
~~~

The app can be reached at http://localhost:5100

If you have created an initial admin user, you can login with email
'example@example.tld' and passwort 'Qu4Mund0'

### Reporting bugs

For reporting bugs use the github [issue
tracker](https://github.com/QuaMundo/quamundo/issues)

