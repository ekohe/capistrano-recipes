namespace :recipes do
  desc "Generate Capistrano Deployment recipes"
  task :generate do
    require 'fileutils'

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

    application_name = ENV['APPLICATION']
    server_name = ENV['SERVER']
    ruby_version = ENV['RUBY']
    redmine_project_name = ENV['REDMINE']
    redmine_key = ENV['KEY']

    if application_name.nil? || server_name.nil? || ruby_version.nil? || redmine_project_name.nil?
      puts "Usage: rake recipes:generate APPLICATION=app SERVER=ekohe.com RUBY=ruby-2.4.1 REDMINE=app KEY=redmine_key"
      exit
    end
    puts "Generating Capistrano deploy recipes with following arguments:"
    puts "Application name: #{application_name}"
    puts "Server name: #{server_name}"
    puts "Ruby version: #{ruby_version}"
    puts "Redmine project name: #{redmine_project_name}"
    puts "Redmine key: #{redmine_key}"


    FileUtils.rm_rf("#{Rails.root}/tmp/recipes/.", secure: true)

    FileUtils.mkdir_p("#{Rails.root}/tmp/recipes/environments/")
    FileUtils.mkdir_p("#{Rails.root}/tmp/recipes/deploy/")

    replace_in_file("deploy", "deploy.rb", [["REDMINE_KEY", redmine_key], ["REDMINE_PROJECT_NAME", redmine_project_name], ["APP_NAME", application_name]])
    copy_files('deploy',"deploy.rb" )

    %w{develop.rb staging.rb production.rb}.each do |file_name|
      replace_in_file("environments", file_name, [["APP_NAME", application_name],["SERVER_NAME", server_name]])
      replace_in_file("deploy", file_name, [["SERVER_NAME", server_name],["RUBY_VERSION", ruby_version]])
    end

    FileUtils.mkdir_p("#{Rails.root}/config/deploy/")
    %w{develop.rb staging.rb production.rb}.each do |file_name|
      %w{deploy environments}.each do |directory|
        copy_files(directory, file_name)
      end
    end

    puts "Capistrano Deployment recipes generated"
  end
end

