source 'http://rubygems.org'

gem 'rails', '= 4.1.1'

gem 'puma',                      require: false
gem 'hirb',                      require: false
gem 'rake',                      require: false
gem 'redis'
gem 'bunny'
gem 'devise'
gem 'wirble',                    require: false
gem 'mongoid',                   '= 4.0.0.rc2'
gem 'slim-rails'
gem 'redis-rails'
gem 'connection_pool'
gem 'rubygems-bundler',          require: false
gem 'active_model_serializers'

gem 'uglifier'
gem 'sprockets',                '= 2.11.0'
gem 'sass-rails',               '~> 4.0'
gem 'ember-rails'
gem 'emblem-rails'
gem 'coffee-rails'
gem 'foundation-rails'
gem 'font-awesome-rails'

group :test, :development do
  gem 'pry'
  gem 'ffaker'
  gem 'listen',                  require: false
  gem 'rb-inotify',              require: false
  gem 'qunit-rails'
  gem 'fabrication'
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
  gem 'jruby-openssl',           require: false
  gem 'activerecord-jdbc-adapter'
  gem 'activerecord-jdbcmysql-adapter'
end

platforms :rbx do
  gem 'rubysl',                  require: false

  group :development, :test do
    gem 'rubinius-coverage',     require: false
    gem 'rubinius-compiler',     require: false
    gem 'rubinius-debugger',     require: false
    gem 'rubinius-profiler',     require: false
  end
end

platforms :ruby do
  gem 'mysql2'
  gem 'git-smart',               require: false
end
