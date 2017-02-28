set :application, 'APP_NAME'
set :repo_url, "gitlab@gitlab.ekohe.com:ekohe/#{fetch(:application)}.git"
ask :branch, 'master'
set :deploy_to, "/var/www/#{fetch(:environment)}/#{fetch(:application)}"
set :user, ENV['CAPISTRANO_USER'] || `whoami`.chop
set :ssh_options, forward_agent: true
set :tmp_dir, "/home/#{fetch(:user)}/tmp"
set :rvm_type, :system
set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml',
)
set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system'
)

set :cr_email, "{fetch(:application)}.dev@ekohe.com"
set :cr_redmine_key, 'REDMINE_KEY'
set :cr_redmine_url, "https://red.ekohe.com/projects/REDMINE_PROJECT_NAME/wiki/revisions_#{fetch(:stage)}.xml"

before 'deploy:starting', 'deploy:revisions'
after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      execute "sudo monit -g #{fetch(:application)}_#{fetch(:environment)}_ruby restart all"
    end
  end
end
