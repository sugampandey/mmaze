require "bundler/capistrano"
require "whenever/capistrano"

default_run_options[:pty] = true

set :bundle_flags,    ""
set :application, "musiquemaze.com"

set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"

set :user, "prod"
set :use_sudo, true

set :repository,  "git@github.com:sugampandey/mmaze.git"
set :scm, :git

set :use_sudo, false
set :ssh_options, { :forward_agent => true }
set :deploy_via, :remote_cache

role :web, "198.101.193.206"
role :app, "198.101.193.206"
role :db,  "198.101.193.206", :primary => true

namespace :deploy do    
  desc "precompiling assets"
  task :precompile_assets, :roles => :app do
    run "cd #{release_path}; RAILS_ENV=production bundle exec rake assets:precompile"
  end
  
  desc "copying database configuration"
  task :copy_database_yml, :roles => :app do
    run "ln -s #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
  
  desc "copying environments configuration"
  task :copy_environments_config, :roles => :app do
    run "ln -s #{shared_path}/app_config.yml #{release_path}/config/app_config.yml"
  end
  
  task :refresh_sitemaps do
    run "cd #{latest_release} && RAILS_ENV=#{rails_env} rake sitemap:refresh"
  end
  
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    sudo "/etc/init.d/thin restart"
    sudo "/etc/init.d/nginx restart"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end

after "deploy:update_code", "deploy:copy_environments_config"
after "deploy:copy_environments_config", "deploy:copy_database_yml"
after "deploy:copy_database_yml", "deploy:precompile_assets"
after "deploy:precompile_assets", "deploy:refresh_sitemaps"

namespace :web do 
  desc "Restart Nginx"
  task :restart_nginx, :roles => :web do
    sudo "/etc/init.d/nginx restart"
  end
  
  desc "Restart Thin"
  task :restart_thin, :roles => :web do
    sudo "/etc/init.d/thin restart"
  end
  
  desc "Go into maintenance mode"
  task :disable, :roles => :web do
    on_rollback { run "rm #{shared_path}/system/maintenance.html" }
    run "if [ ! -f #{shared_path}/system/maintenance.html ] ; then ln -s #{shared_path}/system/maintenance.html.not_active #{shared_path}/system/maintenance.html ; else echo 'maintenance page already up'; fi"
  end
  
  desc "Get out of maintenance mode"
  task :enable, :roles => :web do 
    run "rm #{shared_path}/system/maintenance.html"
  end
end

desc "Sync seed data"
task :sync_seed_data do
  `rsync -qrpt --verbose --exclude ".svn" --progress --delete --rsh=ssh db/data prod@musiquemaze.com:#{current_path}/db`
end

desc "Run Seed"
task :run_seed do 
  run "cd #{current_path}; RAILS_ENV=production bundle exec rake musique_maze:seed_additional_quizzes['db/data']"
end
