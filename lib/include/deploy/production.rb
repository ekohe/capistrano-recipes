set :server, 'SERVER_NAME'
set :branch, 'master'
role :web, [fetch(:server)]
role :db,  [fetch(:server)]
set :environment, 'production'
set :deploy_to, "/var/www/#{fetch(:environment)}/#{fetch(:application)}"
set :rvm_ruby_string, "RUBY_VERSION@#{fetch(:application)}_#{fetch(:environment)}"
set :rvm_ruby_version, fetch(:rvm_ruby_string)

server fetch(:server), user: fetch(:user), roles: %w{web app}
