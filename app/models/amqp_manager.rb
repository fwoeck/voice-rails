class AmqpManager
  include Celluloid

  TOPICS = [:rails, :push, :custom, :ahn]


  TOPICS.each { |name|
    sym = "@#{name}_channel".to_sym
    define_method "#{name}_channel" do
      instance_variable_get(sym) || instance_variable_set(
        sym, connection.create_channel
      )
    end

    sym = "@#{name}_xchange".to_sym
    define_method "#{name}_xchange" do
      instance_variable_get(sym) || instance_variable_set(
        sym, send("#{name}_channel").topic("voice.#{name}", auto_delete: false)
      )
    end

    sym = "@#{name}_queue".to_sym
    define_method "#{name}_queue" do
      instance_variable_get(sym) || instance_variable_set(
        sym, send("#{name}_channel").queue("voice.#{name}", auto_delete: false)
      )
    end
  }


  def push_publish(payload)
    push_xchange.publish(MultiJson.dump(payload), routing_key: 'voice.push')
  end


  def custom_publish(payload)
    custom_xchange.publish(Marshal.dump(payload), routing_key: 'voice.custom')
  end


  def ahn_publish(payload)
    ahn_xchange.publish(Marshal.dump(payload), routing_key: 'voice.ahn')
  end


  def connection
    establish_connection unless @@connection
    @@connection
  end


  def shutdown
    connection.close
  end


  def establish_connection
    @@connection = Bunny.new(
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
      Marshal.load(payload).handle_update
    end if ENV['SUBSCRIBE_AMQP']
  end


  class << self

    def start
      # TODO This will suppress warnings at exit, but could also
      #       mask potential problems. Try to remove after a while:
      #
      Celluloid.logger = nil

      Celluloid::Actor[:amqp] = AmqpManager.pool
      @@manager ||= new.tap { |m| m.start }
    end


    def shutdown
      @@manager.shutdown
    end


    def push_publish(*args)
      Celluloid::Actor[:amqp].async.push_publish(*args)
    end


    def custom_publish(*args)
      Celluloid::Actor[:amqp].async.custom_publish(*args)
    end


    def ahn_publish(*args)
      Celluloid::Actor[:amqp].async.ahn_publish(*args)
    end
  end
end
