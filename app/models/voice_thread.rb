class VoiceThread

  def self.run(&block)
    Thread.new {
      block.call
      ActiveRecord::Base.connection.close
    }
  end
end
