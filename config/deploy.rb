require "bundler/capistrano"
require "airbrake/capistrano"
require "rvm/capistrano"

server "redde.ru", :web, :app, :db

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

namespace :deploy do
  desc "Symlink yml files"
  task :create_symlink, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    run "ln -nfs #{shared_path}/config/oauth.yml #{release_path}/config/oauth.yml"
    run "rm -Rf #{release_path}/public/uploads"
    run "ln -s #{shared_path}/uploads #{release_path}/public/uploads"
  end
end

namespace :unicorn do
  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command, roles: :app do
      run "sudo service #{application} #{command}"
    end
    after "deploy:#{command}", "unicorn:#{command}"
  end
end

after "deploy:finalize_update", "deploy:create_symlink"
after "deploy", "deploy:cleanup" # keep only the last 5 releases
after "deploy", "deploy:sitemap"