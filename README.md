Pulmap (Test 09-29-20-4:09)
======

GeoBlacklight for Princeton University Library

[![CircleCI](https://circleci.com/gh/pulibrary/pulmap.svg?style=svg)](https://circleci.com/gh/pulibrary/pulmap)
[![Coverage Status](https://coveralls.io/repos/pulibrary/pulmap/badge.svg?branch=master&service=github)](https://coveralls.io/github/pulibrary/pulmap?branch=master)

### Installation
```
bundle
rake db:migrate
npm install --global yarn
yarn
```

### Setup server

1. For test:
   - `rake pulmap:test`
   - In a separate terminal: `bundle exec rspec`
2. For development:
   - `rake pulmap:development`
   - In a separate terminal: `rails s`
   - Access Pulmap at http://localhost:3000/

### Auto-update from external services

Pulmap can listen for events published on a RabbitMQ fanout exhange. In order to use them, do the
following:

1. Configure the `events` settings in `config/pulmap.yml`
2. Run `WORKERS=GeoblacklightEventHandler rake sneakers:run`

This will subscribe pulmap to the events and update geoblacklight records when they're
created, updated, or deleted.
