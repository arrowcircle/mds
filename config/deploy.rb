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

after "deploy:finalize_update", "deploy:create_symlink_uploads"
after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "sitemap:refresh"