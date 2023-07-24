Pulmap
======

GeoBlacklight for Princeton University Library

[![CircleCI](https://circleci.com/gh/pulibrary/pulmap.svg?style=svg)](https://circleci.com/gh/pulibrary/pulmap)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)](https://github.com/pulibrary/pulmap)


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

### Reindex from figgy

The reindex is triggered on the figgy side.

```
$ ssh deploy@lib-proc7
$ tmux new -t [yourname]
$ cd /opt/figgy/current
$ BULK=true bundle exec rails c
> GeoResourceReindexer.reindex_geoblacklight
```

It takes a few minutes to get all the complete georesources. Then it invokes the
updated event on each, which sends them to rabbitmq.

Then you'll start to see output like "Indexed into GeoBlacklight:..."

We usually run this overnight.

### Auto-update from external services

Pulmap can listen for events published on a RabbitMQ fanout exhange. In order to use them, do the
following:

1. Configure the `events` settings in `config/pulmap.yml`
2. Run `WORKERS=GeoblacklightEventHandler rake sneakers:run`

This will subscribe pulmap to the events and update geoblacklight records when they're
created, updated, or deleted.
