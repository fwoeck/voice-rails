class VoiceThread

  def self.run(&block)
    Thread.new { block.call }
  end
end
