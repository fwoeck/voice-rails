source 'http://rubygems.org'

gem 'rails', '= 4.1.6'

gem 'puma',                      require: false
gem 'hirb',                      require: false
gem 'rake',                      require: false
gem 'redis'
gem 'bunny'
gem 'rolify'
gem 'devise'
gem 'wirble',                    require: false
gem 'mongoid'
gem 'celluloid'
gem 'multi_json'
gem 'slim-rails'
gem 'redis-rails'
gem 'thread_safe'
gem 'connection_pool'
gem 'rubygems-bundler',          require: false
gem 'active_model_serializers'

gem 'uglifier'
gem 'sprockets'
gem 'sass-rails'
gem 'ember-rails'
gem 'emblem-rails'
gem 'coffee-rails'
gem 'foundation-rails'
gem 'font-awesome-rails'

group :test, :development do
  gem 'pry'
  gem 'faker'
  gem 'listen',                  require: false
  gem 'rb-inotify',              require: false
  gem 'qunit-rails'
  gem 'factory_girl'
end

group :test do
  gem 'timecop'
  gem 'rspec-rails'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'capybara-screenshot'
end

platforms :mri do
  group :development, :test do
    gem 'byebug'
  end
end

platforms :jruby do
  gem 'jrjackson'
  gem 'jruby-openssl',           require: false
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcmysql-adapter'
end

platforms :ruby do
  gem 'oj'
  gem 'mysql2'
  gem 'git-smart',               require: false

  group :development do
    gem 'spring-commands-rspec', require: false
    gem 'guard-spring',          require: false
    gem 'guard-rspec',           require: false
    gem 'spring',                require: false
  end
end
