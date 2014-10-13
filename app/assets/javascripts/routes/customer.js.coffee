Voice.CustomerRoute = Ember.Route.extend({

  beforeModel: (t) ->
    t.abort() unless env.railsEnv == 'development'


  deactivate: ->
    @store.unloadAll('customer')
    @store.unloadAll('crmTicket')
    @store.unloadAll('historyEntry')


  model: (params) ->
    @store.find('customer', params.customer_id)
})
