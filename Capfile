# frozen_string_literal: true

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# include bundler
require "capistrano/bundler"

# rails asset migrations
require "capistrano/rails/assets"

# run db migrations
require "capistrano/rails/migrations"

# deploy/restart task for passenger
require "capistrano/passenger"

# include console
require "capistrano/rails/console"

# Run whenever crontab update tasks
# https://github.com/javan/whenever/blob/master/lib/whenever/capistrano/v3/tasks/whenever.rake#L39-L40
require "whenever/capistrano"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
