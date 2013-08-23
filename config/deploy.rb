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

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end


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