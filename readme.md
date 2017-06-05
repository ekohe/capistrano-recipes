### capistrano-recipes

#### About
Provides recipes:generate rake task to generate capistrano recipes for deployment.

```
rake recipes:generate APPLICATION=application_name SERVER=server_address RUBY=ruby_version REDMINE=redmine_project_name KEY=redmine_key
```

- APPLICATION: this is the namem of the application and directory i.e. /var/www/production/app_name
- RUBY: ruby version string i.e. ruby-2.4.1
- REDMINE: (capistrano-revisions prerequisite) Redmine project name as seen in https://redmine.domain.com/projects/app_name i.e. app_name
- KEY: (capistrano-revisions prerequisite) Redmine API key so that the capistrano-revisions gem can create wiki entries

Which will generate

```
config/deploy.rb
config/deploy/develop.rb
config/deploy/staging.rb
config/deploy/production.rb
config/environments/develop.rb
config/environments/staging.rb
config/environments/production.rb
```

prefill everything accordingly and modify your Gemfile adding:

1. all gems necessary to install capistrano
1. [capistrano-revisions](https://github.com/maverick9000/capistrano-revisions) gem

It will also modify you Capfile to enable capistrano-revisions

#### Installation

Add to your gemfile

```
gem 'capistrano_recipes', require: false, git: 'https://github.com/ekohe/capistrano-recipes'
```
