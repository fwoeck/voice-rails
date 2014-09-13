class RemoteRequest

  Registry = ThreadSafe::Cache.new
  attr_accessor :id, :verb, :klass, :params, :req_from, :res_to, :value


  def handle_update
    future = Registry[id]
    future << value if future
  end


  class << self

    def new_request_id
      BSON::ObjectId.new.to_s
    end


    def rpc_to_custom(*args)
      rpc_to_service(:custom, *args)
    end


    def rpc_to_service(target, klass, verb, params)
      id      = new_request_id
      future  = Celluloid::Future.new
      request = build_fom(id, verb, klass, params)

      Registry[id] = future
      AmqpManager.send("#{target}_publish", request)

      result = future.value(5)
    rescue => e
      # ...
    ensure
      Registry.delete id
      result
    end


    def build_fom(id, verb, klass, params)
      RemoteRequest.new.tap { |r|
        r.id       =  id
        r.verb     =  verb
        r.klass    =  klass
        r.params   =  params
        r.req_from = 'voice.rails'
      }
    end
  end
end
