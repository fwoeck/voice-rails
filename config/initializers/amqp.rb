module AMQPManager

  def self.channel
    Thread.current[:channel] ||= @connection.create_channel
  end

  def self.xchange
    Thread.current[:xchange] ||= channel.topic('voice.ahn', auto_delete: false)
  end

  def self.ahn_publish(*args)
    xchange.publish(*args)
  end

  def self.shutdown
    @connection.close
  end

  def self.start
    @connection = Bunny.new(
      host:     WimConfig['rabbit_host'],
      user:     WimConfig['rabbit_user'],
      password: WimConfig['rabbit_pass']
    )
    @connection.start

    queue = channel.queue('voice.ahn', auto_delete: false)
    queue.bind(xchange, routing_key: 'voice.ahn')

    queue.subscribe do |delivery_info, metadata, payload|
      Rails.logger.info "Received AMQP-Message: #{payload}"
    end
  end
end

AMQPManager.start
