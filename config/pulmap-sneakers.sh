#!/bin/bash

# Logs out to /var/log/upstart/sidekiq.log by default
source /home/deploy/.bashrc
cd /opt/rails_app/current
export RAILS_ENV=production
exec bundle exec rake sneakers:run WORKERS=GeoblacklightEventHandler RAILS_ENV=production > log/sneakers.log