# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'pulmap'
set :repo_url, 'git@github.com:pulibrary/pulmap.git'
set :branch, 'master'

# Default branch is :master
set :branch, ENV['BRANCH'] || 'master'

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/opt/pulmap'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# need tty for sudo
set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/blacklight.yml',
                                                 'config/database.yml',
                                                 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache/downloads',
                                               'tmp/sockets',
                                               'public/thumbnails')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

##
# pasenger needs sudo for restart
# Steps on server:
# 1. Create file: /etc/sudoers.d/deployer_username
# 2. Add to file: deployer_username ALL=(ALL) NOPASSWD:/usr/bin/env,/usr/local/bin/passenger-config
set :passenger_restart_with_sudo, true

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
