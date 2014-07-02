require 'rails_helper'

Dir["#{File.dirname(__FILE__)}/../factories/**/*.rb"].each { |name| require name }
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |name| require name }
