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
rake jetty:download
rake jetty:unzip
rake geoblacklight:configure_solr
rake jetty:start
rake geoblacklight:solr:seed
rails server
```
###Production Requirements

####mod_xsendfile

    $ sudo apt-get install libapache2-mod-xsendfile
