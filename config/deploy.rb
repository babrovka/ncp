require 'rvm/capistrano'
require 'bundler/capistrano'

load 'deploy/assets'

server "5.178.80.26", :web, :app, :db, primary: true

set :user, "user"
set :application, "ncp"
set :deploy_to, "/home/user/projects/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@github.com:babrovka/ncp.git"
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true




namespace(:thin) do
  task :stop do
    run "thin stop -C /etc/thin/ncp.yml"
   end
  
  task :start do
    run "thin start -C /etc/thin/ncp.yml"
  end

  task :restart do
    run "thin restart -C /etc/thin/ncp.yml"
  end
end


after "deploy", "deploy:cleanup"