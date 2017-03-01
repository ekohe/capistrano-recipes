require 'fileutils'

namespace :recipes do
  desc "Generate Capistrano Deployment recipes"
  task :generate do
    setup_variables
    create_directories
    create_deploy_recipes
    create_environments
    modify_gemfile
    update_bundle
    modify_capfile
    puts "Capistrano Deployment recipes generated"
  end

  def modify_capfile
    FileUtils.cp("#{Gem::Specification.find_by_name("capistrano_recipes").gem_dir}/lib/include/Capfile","#{Rails.root}/Capfile")
  end

  def setup_variables
    @application_name = ENV['APPLICATION']
    @server_name = ENV['SERVER']
    @ruby_version = ENV['RUBY']
    @redmine_project_name = ENV['REDMINE']
    @redmine_key = ENV['KEY']

    if @application_name.nil? || @server_name.nil? || @ruby_version.nil? || @redmine_project_name.nil? || @redmine_key.nil?
      puts "Error: insufficient arguments"
      puts "Usage: rake recipes:generate APPLICATION=app SERVER=ekohe.com RUBY=ruby-2.4.1 REDMINE=app KEY=@redmine_key"
      exit
    end

    puts "Generating Capistrano deploy recipes with following arguments:"
    puts "Application name: #{@application_name}"
    puts "Server name: #{@server_name}"
    puts "Ruby version: #{@ruby_version}"
    puts "Redmine project name: #{@redmine_project_name}"
    puts "Redmine key: #{@redmine_key}"
  end

  def create_environments
    %w{develop.rb staging.rb production.rb}.each do |file_name|
      %w{deploy environments}.each do |directory|
        copy_files(directory, file_name)
      end
    end
  end

  def create_deploy_recipes
    replace_in_file("deploy", "deploy.rb", [["REDMINE_KEY", @redmine_key], ["REDMINE_PROJECT_NAME", @redmine_project_name], ["APP_NAME", @application_name]])
    copy_files('deploy',"deploy.rb" )

    %w{develop.rb staging.rb production.rb}.each do |file_name|
      replace_in_file("environments", file_name, [["APP_NAME", @application_name],["SERVER_NAME", @server_name]])
      replace_in_file("deploy", file_name, [["SERVER_NAME", @server_name],["RUBY_VERSION", @ruby_version]])
    end
  end

  def create_directories
    FileUtils.rm_rf("#{Rails.root}/tmp/recipes/.", secure: true)

    FileUtils.mkdir_p("#{Rails.root}/tmp/recipes/environments/")
    FileUtils.mkdir_p("#{Rails.root}/tmp/recipes/deploy/")
    FileUtils.mkdir_p("#{Rails.root}/config/deploy/")
  end

  def modify_gemfile
    gemfile = "#{Rails.root}/Gemfile"
    unless gemfile_modified(gemfile)
      open(gemfile, 'a') do |f|
        f.puts "group :development do"
        f.puts "\tgem 'capistrano-rails'"
        f.puts "\tgem 'capistrano-rvm'"
        f.puts "\tgem 'capistrano-revisions', require: false, git: 'https://github.com/ekohe/capistrano-revisions'"
        f.puts "\tgem 'capistrano-helpers', require: false, git: 'https://github.com/ekohe/capistrano-helpers'"
        f.puts "end"
      end
    end
  end

  def gemfile_modified(gemfile)
    puts "rails?:#{File.readlines(gemfile).grep(/capistrano-rails/).size > 0}"
    ((File.readlines(gemfile).grep(/capistrano-rails/).size > 0) &&
    (File.readlines(gemfile).grep(/capistrano-rvm/).size > 0) &&
    (File.readlines(gemfile).grep(/capistrano-revisions/).size > 0) &&
    (File.readlines(gemfile).grep(/capistrano-helpers/).size > 0))
  end

  def update_bundle
    system("cd #{Rails.root}; bundle install")
  end

  def replace_in_file(directory, file_name, replacements)
    content = File.read("#{Gem.loaded_specs["capistrano_recipes"].gem_dir}/lib/include/#{directory}/#{file_name}")
    replacements.each do |old_text, new_text|
      content = content.gsub(old_text, new_text)
    end
    File.open("#{Rails.root}/tmp/recipes/#{directory}/#{file_name}", "w") {|file| file.puts content }
  end

  def copy_files(directory, file_name)
    if directory == 'environments'
      destination = "#{Rails.root}/config/environments/"
    elsif file_name == 'deploy.rb'
      destination = "#{Rails.root}/config/"
    else
      destination = "#{Rails.root}/config/deploy/"
    end
    FileUtils.cp("#{Rails.root}/tmp/recipes/#{directory}/#{file_name}", "#{destination}/#{file_name}")
  end
end

