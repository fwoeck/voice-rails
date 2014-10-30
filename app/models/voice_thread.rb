class VoiceThread

  def self.async(&block)
    Thread.new { with_sql { yield block } }
  end


  def self.with_sql(&block)
    ActiveRecord::Base.connection_pool.with_connection {
      yield block
    }
  rescue Exception => e
    Rails.logger.error e.message
    ActiveRecord::Base.connection.try(:close)
  end
end
