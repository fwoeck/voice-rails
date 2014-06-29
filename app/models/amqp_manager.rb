module AmqpManager
  class << self


    def rails_channel
      Thread.current[:rails_channel] ||= @connection.create_channel
    end


    def rails_xchange
      Thread.current[:rails_xchange] ||= rails_channel.topic('voice.rails', auto_delete: false)
    end


    def rails_queue
      Thread.current[:rails_queue] ||= rails_channel.queue('voice.rails', auto_delete: false)
    end


    def push_channel
      Thread.current[:push_channel] ||= @connection.create_channel
    end


    def push_xchange
      Thread.current[:push_xchange] ||= push_channel.fanout('voice.push', auto_delete: false)
    end


    def push_publish(payload)
      push_xchange.publish(payload)
    end


    def shutdown
      @connection.close
    end


    def establish_connection
      @connection = Bunny.new(
        host:     WimConfig['rabbit_host'],
        user:     WimConfig['rabbit_user'],
        password: WimConfig['rabbit_pass']
      ).tap { |c| c.start }
    end


    def start
      establish_connection

      rails_queue.bind(rails_xchange, routing_key: 'voice.rails')
      rails_queue.subscribe do |delivery_info, metadata, payload|
        # ...
        push_publish(payload)
      end
    end
  end
end
