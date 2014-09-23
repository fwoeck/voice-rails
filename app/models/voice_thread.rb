class VoiceThread

  def self.run(&block)
    Thread.new {
      block.call
      ActiveRecord::Base.clear_active_connections!
    }
  end
end
