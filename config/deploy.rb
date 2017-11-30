# config valid only for current version of Capistrano
lock '>=3.4'

set :application, 'pulmap'
set :repo_url, 'https://github.com/pulibrary/pulmap.git'
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

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache/downloads',
                                               'tmp/sockets',
                                               'tmp/thumbnails')

set :passenger_restart_with_touch, true

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

namespace :sneakers do
  task :restart do
    on roles(:worker) do
      execute :sudo, :service, 'pulmap-sneakers', :restart
    end
  end
end

after 'deploy:reverted', 'sneakers:restart'
after 'deploy:published', 'sneakers:restart'
