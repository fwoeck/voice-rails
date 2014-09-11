class AmqpRequest

  Registry = ThreadSafe::Cache.new
  attr_accessor :id, :verb, :klass, :params, :req_from, :res_to, :value


  def handle_update
    req = Registry[id]
    req << value if req
  end


  class << self

    def new_request_id
      BSON::ObjectId.new.to_s
    end


    def rpc_to_custom(klass, verb, params)
      id   = new_request_id
      req  = Celluloid::Future.new
      data = AmqpRequest.new.tap { |r|
        r.id       =  id
        r.verb     =  verb
        r.klass    =  klass
        r.params   =  params
        r.req_from = 'voice.rails'
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
  end
end
