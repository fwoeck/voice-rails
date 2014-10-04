Voice.CustomerRoute = Ember.Route.extend({

  deactivate: ->
    @store.unloadAll('customer')
    @store.unloadAll('crmTicket')
    @store.unloadAll('historyEntry')


  model: (params) ->
    @store.find('customer', params.customer_id)
})
