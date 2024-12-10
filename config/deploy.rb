# frozen_string_literal: true

# config valid only for current version of Capistrano
lock ">=3.4"

set :application, "pulmap"
set :repo_url, "https://github.com/pulibrary/pulmap.git"

# Default branch is :main
set :branch, ENV["BRANCH"] || "main"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/opt/pulmap"

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# need tty for sudo
set :pty, true

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push("log",
                                               "tmp/pids",
                                               "tmp/cache/downloads",
                                               "tmp/sockets",
                                               "tmp/thumbnails")

set :passenger_restart_with_touch, true

desc "Write the current version to public/version.txt"
task :write_version do
  on roles(:app), in: :sequence do
    within repo_path do
      execute :tail, "-n1 ../revisions.log > #{release_path}/public/version.txt"
    end
  end
end
after "deploy:log_revision", "write_version"

namespace :sneakers do
  task :restart do
    on roles(:worker) do
      execute :sudo, :service, "pulmap-sneakers", :restart
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
      execute :sudo, :service, "sidekiq-workers", :restart
    end
  end
end
after "deploy:starting", "sidekiq:quiet"
after "deploy:reverted", "sidekiq:restart"
after "deploy:reverted", "sneakers:restart"
after "deploy:published", "sidekiq:restart"
after "deploy:published", "sneakers:restart"

namespace :deploy do
  desc "Run yarn install"
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
      execute :rake, "pulmap:robots_txt"
    end
  end
end
after "deploy:published", "robots_txt"

namespace :solr do
  desc "Opens Solr Console"
  task :console do
    primary_app = primary(:app)
    solr_host = fetch(:stage, "production").to_s == "production" ? "lib-solr-prod7" : "lib-solr-staging4d"
    port = rand(9000..9999)
    puts "Opening Solr Console on port #{port}"
    Net::SSH.start(solr_host, primary_app.user) do |session|
      session.forward.local(port, "localhost", 8983)
      puts "Press Ctrl+C to end Console connection"
      `open http://localhost:#{port}`
      session.loop(0.1) { true }
    end
  end
end
