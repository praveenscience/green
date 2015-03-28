# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'green'

set :repo_url, 'git@heroku.com:greenctf.git'

set :default_env, { path: "$PATH" }

set :deploy_via, :copy

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '~/green'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# namespace :deploy do

#   # Change the restart function to run "forever"
#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       execute "forever start #{release_path.join('server/app.js')}"
#     end
#   end

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end


namespace :deploy do
    task :start do
      on roles(:app), in: :sequence do
        run "sudo restart #{application} || sudo start #{application}"
      end
    end

    task :stop do
      on roles(:app), in: :sequence do
        run "sudo stop #{application}"
      end
    end

    task :restart do
      on roles(:app), in: :sequence do
        start
      end
    end

    # task :npm_install do
    #   on roles(:app), in: :sequence do
    #     run "cd #{release_path} && npm install"
    # end
end

# after "deploy:update", "deploy:cleanup"
# after "deploy:update_code", "deploy:npm_install"




