Pulmap
======

GeoBlacklight for Princeton University Library

[![Build Status](https://travis-ci.org/pulibrary/pulmap.png?branch=master)](https://travis-ci.org/pulibrary/pulmap)
[![Coverage Status](https://coveralls.io/repos/pulibrary/pulmap/badge.svg?branch=master&service=github)](https://coveralls.io/github/pulibrary/pulmap?branch=master)
[![Stories in Ready](https://badge.waffle.io/pulibrary/pulmap.png?label=ready&title=Ready)](https://waffle.io/pulibrary/pulmap)

###Installation
```
bundle
cp config/database.yml.tmpl config/database.yml
rake db:migrate
rake geoblacklight:server
```
To index sample data into solr, in another terminal run:
```
rake geoblacklight:solr:seed
```
###Production Requirements

####mod_xsendfile

    $ sudo apt-get install libapache2-mod-xsendfile

### Auto-update from external services

Pulmap can listen for events published on a RabbitMQ fanout exhange. In order to use them, do the
following:

1. Configure the `events` settings in `config/config.yml`
2. Run `WORKERS=GeoblacklightEventHandler rake sneakers:run`

This will subscribe pulmap to the events and update geoblacklight records when they're
created, updated, or deleted.
