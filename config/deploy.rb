require 'bundler/capistrano'
load 'deploy/assets'

module UseScpForDeployment
  def self.included(base)
    base.send(:alias_method, :old_upload, :upload)
    base.send(:alias_method, :upload,     :new_upload)
  end

  def new_upload(from, to, options = {}, &block)
  old_upload(from, to, options.merge(:via => :scp), &block)
  end
end

task :copy_database_config do
   run "ln -nfs #{shared_path}/development.sqlite3 #{latest_release}/db/development.sqlite3"
end

Capistrano::Configuration.send(:include, UseScpForDeployment)

server "mars.cyclonelabs.com", :web, :app, :db, primary: true
ssh_options[:port] = 33910

set :user, "babrovka"
set :application, "scaegroup"
set :deploy_to, "/srv/webapp/#{application}"
set :use_sudo, false
set :scm, :none
set :repository, "."
set :deploy_via, :copy
set :local_repository, "."
set :branch, "master"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

namespace :deploy do
  namespace :assets do
    task :precompile, :roles => :web, :except => { :no_release => true } do
      from = source.next_revision(current_revision)
      if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
        run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile --trace}
      else
        logger.info "Skipping asset pre-compilation because there were no asset changes"
      end
    end
  end
end

before "deploy:assets:precompile", "copy_database_config"
after "deploy", "deploy:cleanup"


# require 'rvm/capistrano'
# require 'bundler/capistrano'
# 
# load 'deploy/assets'
# 
# server "5.178.80.26", :web, :app, :db, primary: true
# 
# set :user, "user"
# set :application, "ncp"
# set :deploy_to, "/home/user/projects/#{application}"
# set :deploy_via, :remote_cache
# set :use_sudo, false
# 
# set :scm, "git"
# set :repository, "git@github.com:babrovka/ncp.git"
# set :branch, "master"
# 
# default_run_options[:pty] = true
# ssh_options[:forward_agent] = true
# 
# namespace :deploy do
#   namespace :assets do
#     task :precompile, :roles => :web, :except => { :no_release => true } do
#       from = source.next_revision(current_revision)
#       if capture("cd #{latest_release} && #{source.local.log(from)} vendor/assets/ app/assets/ | wc -l").to_i > 0
#         run %Q{cd #{latest_release} && #{rake} RAILS_ENV=#{rails_env} #{asset_env} assets:precompile}
#       else
#         logger.info "Skipping asset pre-compilation because there were no asset changes"
#       end
#     end
#   end
# end
# 
task :copy_database_config do
   run "ln -nfs #{shared_path}/development.sqlite3 #{latest_release}/db/development.sqlite3"
end
# 
# 
# namespace(:thin) do
#   task :stop do
#     run "thin stop -C /etc/thin/ncp.yml"
#    end
#   
#   task :start do
#     run "thin start -C /etc/thin/ncp.yml"
#   end
# 
#   task :restart do
#     run "thin restart -C /etc/thin/ncp.yml"
#   end
# end
# 
# before "deploy:assets:precompile", "copy_database_config"
# after "deploy", "deploy:cleanup"