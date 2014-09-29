class VoiceThread

  def self.async(&block)
    Thread.new { with_db { yield block } }
  end


  def self.with_db(&block)
    ActiveRecord::Base.connection_pool.reap
    yield block
  rescue Exception => e
    raise e
  ensure
    ActiveRecord::Base.connection.close if ActiveRecord::Base.connection
    ActiveRecord::Base.clear_active_connections!
  end
end
