Rails.application.config.after_initialize do
  ActiveRecord::Base.connection_pool.disconnect!
end
