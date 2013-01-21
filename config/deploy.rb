require "bundler/capistrano"
require "airbrake/capistrano"
require "rvm/capistrano"

server "redde.ru", :web, :app, :db, :primary => true

set :user, "webmaster"
set :application, "mds"
set :deploy_to, "/home/#{user}/projects/production/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git://github.com/arrowcircle/mds.git"
set :branch, "master"
set :rvm_ruby_string, '1.9.3@mds'

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :sitemap do
  task :refresh do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh -s"
  end
end

namespace :deploy do
  desc "Symlink yml files"
  task :create_symlink_uploads, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/oauth.yml #{release_path}/config/oauth.yml"
    run "rm -Rf #{release_path}/public/uploads"
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

namespace :unicorn do
  %w[start stop].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "sudo service #{application} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end

  desc "restart unicorn"
  task :restart, roles: :app do
    run "sudo service #{application} stop"
    sleep 2
    run "sudo service #{application} start"
  end
  after "deploy:restart", "unicorn:restart"
end

namespace :sync do
  desc "Dump remote production postgresql database, rsync to localhost"
  task :db do
    get("#{current_path}/config/database.yml", "tmp/database.yml")

    remote_settings = YAML::load_file("config/database.yml")["production"]
    local_settings  = YAML::load_file("config/database.yml")["development"]

    run "export PGPASSWORD=#{remote_settings["password"]} && pg_dump --host=#{remote_settings["host"]} --port=#{remote_settings["port"]} --username #{remote_settings["username"]} --file #{current_path}/tmp/#{remote_settings["database"]}_dump --no-owner -Fc #{remote_settings["database"]}"

    run_locally "rsync --recursive --times --rsh=ssh --compress --human-readable --progress #{current_path}/tmp/#{remote_settings["database"]}_dump tmp/"

    run_locally "dropdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} #{local_settings["database"]}"
    run_locally "createdb -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -T template0 #{local_settings["database"]}"
    run_locally "pg_restore -U #{local_settings["username"]} --host=#{local_settings["host"]} --port=#{local_settings["port"]} -d #{local_settings["database"]} --no-owner tmp/#{remote_settings["database"]}_dump"
  end
end

after "deploy:finalize_update", "deploy:create_symlink_uploads"
after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "sitemap:refresh"