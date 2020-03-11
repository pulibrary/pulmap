# frozen_string_literal: true

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

namespace :sneakers do
  task :restart do
    on roles(:worker) do
      execute :sudo, :service, 'pulmap-sneakers', :restart
    end
  end
end

namespace :sidekiq do
  task :quiet do
    # Horrible hack to get PID without having to use terrible PID files
    on roles(:worker) do
      puts capture("kill -USR1 $(sudo service sidekiq-workers status | grep /running | awk '{print $NF}') || :")
    end
  end
  task :restart do
    on roles(:worker) do
      execute :sudo, :service, 'sidekiq-workers', :restart
    end
  end
end
after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:reverted', 'sneakers:restart'
after 'deploy:published', 'sidekiq:restart'
after 'deploy:published', 'sneakers:restart'

namespace :deploy do
  desc 'Run yarn install'
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install")
      end
    end
  end
end
before "deploy:assets:precompile", "deploy:yarn_install"

task :robots_txt do
  on roles(:app) do
    within release_path do
      execute :rake, 'pulmap:robots_txt'
    end
  end
end
after 'deploy:published', 'robots_txt'

desc "Generate the crontab tasks using Whenever"
task :whenever do
  on roles(:db) do
    within release_path do
      execute("cd #{release_path} && bundle exec whenever --update-crontab #{fetch :application} --set environment=#{fetch :rails_env, fetch(:stage, 'production')} --user deploy")
    end
  end
end
before "deploy:assets:precompile", "whenever"
