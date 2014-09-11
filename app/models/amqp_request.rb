module AmqpRequest

  Registry = ThreadSafe::Cache.new

  class << self

    def new_request_id
      BSON::ObjectId.new.to_s
    end


    def rpc_to_custom(klass, verb, params)
      id   = new_request_id
      req  = Celluloid::Future.new
      data = {
        id:        id,
        verb:      verb,
        class:     klass,
        params:    params,
        req_from: 'voice.rails'
      }

      Registry[id] = req
      AmqpManager.custom_publish(data)

      result = req.value(5)
    rescue => e
      # ...
    ensure
      Registry.delete id
      result
    end


    def handle_response(data)
      req = Registry[data[:id]]
      req << data[:value] if req
    end
  end
end
