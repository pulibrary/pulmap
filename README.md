Pulmap
======

GeoBlacklight for Princeton University Library

###Installation
```
bundle
cp config/blacklight.yml.tmpl config/blacklight.yml
cp config/database.yml.tmpl config/database.yml
cp config/secrets.yml.tmpl config/secrets.yml
rake db:migrate
rake jetty:download
rake jetty:unzip
rake geoblacklight:configure_solr
rake jetty:start
rake geoblacklight:solr:seed
rails server
```
