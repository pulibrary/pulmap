Pulmap
======

GeoBlacklight for Princeton University Library

[![CircleCI](https://circleci.com/gh/pulibrary/pulmap.svg?style=svg)](https://circleci.com/gh/pulibrary/pulmap)
[![Coverage](https://img.shields.io/badge/coverage-99.64%25-brightgreen)](https://github.com/pulibrary/pulmap)


### Initial Setup
```sh
git clone https://github.com/pulibrary/pulmap.git
cd pulmap
bundle install
yarn install
```

### Setup server

1. Install Lando DMG from https://github.com/lando/lando/releases
1. To start: `rake servers:start`
1. For test:
   - `bundle exec rspec`
1. For development:
   - `rails s`
   - Access Pulmap at http://localhost:3000/
1. To stop: `rake servers:stop` or `lando stop`

### Auto-update from external services

Pulmap can listen for events published on a RabbitMQ fanout exhange. In order to use them, do the
following:

1. Configure the `events` settings in `config/pulmap.yml`
2. Run `WORKERS=GeoblacklightEventHandler rake sneakers:run`

This will subscribe pulmap to the events and update geoblacklight records when they're
created, updated, or deleted.
