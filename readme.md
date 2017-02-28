### capistrano-recipes

Provides

```
rake recipes:generate APPLICATION=application_name SERVER=server_address RUBY=ruby_version REDMINE=redmine_project_name KEY=redmine_key
```

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

and prefill everything accordingly.

It works in conjuction with [capistrano-revisions](https://github.com/maverick9000/capistrano-revisions) that's why it asks for redmine project and key.

