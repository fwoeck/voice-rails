module AmqpManager

  class << self

    def rails_channel
      Thread.current[:rails_channel] ||= connection.create_channel
    end

    def rails_xchange
      Thread.current[:rails_xchange] ||= rails_channel.topic('voice.rails', auto_delete: false)
    end

    def rails_queue
      Thread.current[:rails_queue] ||= rails_channel.queue('voice.rails', auto_delete: false)
    end


    def push_channel
      Thread.current[:push_channel] ||= connection.create_channel
    end

    def push_xchange
      Thread.current[:push_xchange] ||= push_channel.topic('voice.push', auto_delete: false)
    end

    def push_publish(payload)
      push_xchange.publish(payload.to_json, routing_key: 'voice.push')
      true
    end


    def custom_channel
      Thread.current[:custom_channel] ||= connection.create_channel
    end

    def custom_xchange
      Thread.current[:custom_xchange] ||= custom_channel.topic('voice.custom', auto_delete: false)
    end

    def custom_queue
      Thread.current[:custom_queue] ||= custom_channel.queue('voice.custom', auto_delete: false)
    end

    def custom_publish(payload)
      custom_xchange.publish(payload.to_json, routing_key: 'voice.custom')
      true
    end


    def ahn_channel
      Thread.current[:ahn_channel] ||= connection.create_channel
    end

    def ahn_xchange
      Thread.current[:ahn_xchange] ||= ahn_channel.topic('voice.ahn', auto_delete: false)
    end

    def ahn_queue
      Thread.current[:ahn_queue] ||= ahn_channel.queue('voice.ahn', auto_delete: false)
    end

    def ahn_publish(payload)
      ahn_xchange.publish(payload.to_json, routing_key: 'voice.ahn')
      true
    end


    def shutdown
      connection.close
    end


    def connection
      establish_connection unless @connection
      @connection
    end


    def establish_connection
      @connection = Bunny.new(
        host:     WimConfig.rabbit_host,
        user:     WimConfig.rabbit_user,
        password: WimConfig.rabbit_pass
      ).tap { |c| c.start }
    rescue Bunny::TCPConnectionFailed
      sleep 1
      retry
    end


    def start
      establish_connection
      return if Rails.env.test?

      rails_queue.bind(rails_xchange, routing_key: 'voice.rails')
      rails_queue.subscribe do |delivery_info, metadata, payload|
        data = JSON.parse(payload)

        if data['res_to']
          AmqpRequest.handle_response data
        else
          CallEvent.handle_update data
        end
      end if ENV['SUBSCRIBE_AMQP']
    end
  end
end
