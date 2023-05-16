# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, "data_layer_app"
set :repo_url, "git@github.com:data-layer/data_layer_app.git"

# Deploy to the user's home directory
set :deploy_to, "/home/deploy/#{fetch :application}"

append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads', 'storage'
append :linked_files, 'config/master.key'
# Only keep the last 5 releases to save disk space
set :keep_releases, 5

set :branch, 'main'

set(:sidekiq_config, 'config/sidekiq.yml')
set(:sidekiq_concurrency, 1)
set(:sidekiq_queue,%w(default high low))
set(:sidekiq_processes, 1)
set :rbenv_type, :user
set :rbenv_ruby, '3.2.0'


# Optionally, you can symlink your database.yml and/or secrets.yml file from the shared directory during deploy
# This is useful if you don't want to use ENV variables
# append :linked_files, 'config/database.yml', 'config/secrets.yml'
