class AmqpManager
  include Celluloid

  USE_JRB = RUBY_PLATFORM =~ /java/
  TOPICS  = [:rails, :push, :custom, :ahn, :numbers]


  TOPICS.each { |name|
    class_eval %Q"
      def #{name}_channel
        @#{name}_channel ||= connection.create_channel
      end
    "

    class_eval %Q"
      def #{name}_xchange
        @#{name}_xchange ||= #{name}_channel.topic('voice.#{name}', auto_delete: false)
      end
    "

    class_eval %Q"
      def #{name}_queue
        @#{name}_queue ||= #{name}_channel.queue('voice.#{name}', auto_delete: false)
      end
    "

    class_eval %Q"
      def #{name}_publish(payload)
        VoiceThread.with_sql {
          #{name}_xchange.publish(Marshal.dump(payload), routing_key: 'voice.#{name}')
        }
      end
    "

    class_eval %Q"
      def self.#{name}_publish(*args)
        Celluloid::Actor[:amqp].#{name}_publish(*args)
      end
    "
  }


  def push_publish(payload)
    VoiceThread.with_sql {
      push_xchange.publish(MultiJson.dump(payload), routing_key: 'voice.push')
    }
  end


  def connection
    establish_connection unless @@connection
    @@connection
  end


  def shutdown
    connection.close
  end


  def establish_connection
    USE_JRB ? establish_marchhare_connection : establish_bunny_connection
  end


  def establish_bunny_connection
    @@connection = Bunny.new(amqp_config).tap { |c| c.start }
  rescue Bunny::TCPConnectionFailed
    sleep 1
    retry
  end


  def establish_marchhare_connection
    @@connection = MarchHare.connect(amqp_config)
  rescue MarchHare::ConnectionRefused
    sleep 1
    retry
  end


  def amqp_config
    { host:     WimConfig.rabbit_host,
      user:     WimConfig.rabbit_user,
      password: WimConfig.rabbit_pass
    }
  end


  def start
    establish_connection
    return if Rails.env.test?

    rails_queue.bind(rails_xchange, routing_key: 'voice.rails')
    rails_queue.subscribe(blocking: false) do |*args|
      Marshal.load(USE_JRB ? args[0] : args[2]).handle_message
    end if ENV['SUBSCRIBE_AMQP']
  end


  class << self

    def start
      return if defined?(@@manager)
      prepare_cleanup

      Celluloid.logger.level = 3
      Celluloid::Actor[:amqp] = AmqpManager.pool(size: 32)
      @@manager = new.tap { |m| m.start }
    end


    def prepare_cleanup
      at_exit do
        AmqpManager.shutdown
        Celluloid.shutdown
      end
    end


    def shutdown
      @@manager.shutdown
    end
  end
end
