module AmqpManager
  TOPICS = [:rails, :push, :custom, :ahn]

  class << self

    def close_channels
      TOPICS.each { |name| Thread.current["#{name}_channel".to_sym].try(:close) }
    end


    TOPICS.each { |name|
      define_method "#{name}_channel" do
        Thread.current["#{name}_channel".to_sym] ||= connection.create_channel
      end

      define_method "#{name}_xchange" do
        Thread.current["#{name}_xchange".to_sym] ||= send("#{name}_channel").topic("voice.#{name}", auto_delete: false)
      end

      define_method "#{name}_queue" do
        Thread.current["#{name}_queue".to_sym] ||= send("#{name}_channel").queue("voice.#{name}", auto_delete: false)
      end
    }


    def push_publish(payload)
      push_xchange.publish(MultiJson.dump(payload), routing_key: 'voice.push')
      true
    end


    def custom_publish(payload)
      custom_xchange.publish(Marshal.dump(payload), routing_key: 'voice.custom')
      true
    end


    def ahn_publish(payload)
      ahn_xchange.publish(Marshal.dump(payload), routing_key: 'voice.ahn')
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


    def is_rpc_response?(data)
      data.is_a?(Hash) && data[:res_to]
    end


    def start
      establish_connection
      return if Rails.env.test?

      rails_queue.bind(rails_xchange, routing_key: 'voice.rails')
      rails_queue.subscribe do |delivery_info, metadata, payload|
        data = Marshal.load(payload)

        if is_rpc_response?(data)
          AmqpRequest.handle_response(data)
        else
          CallEvent.handle_update(data)
        end
      end if ENV['SUBSCRIBE_AMQP']
    end
  end
end
