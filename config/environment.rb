# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

require_dependency './app/models/amqp_manager'

if defined?(Spring)
  Spring.after_fork do
    AmqpManager.start
  end
else
  AmqpManager.start
end
