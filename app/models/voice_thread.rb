class VoiceThread

  def self.run(&block)
    Thread.new {
      block.call
      AmqpManager.close_channels
      ActiveRecord::Base.connection.close
    }
  end
end
