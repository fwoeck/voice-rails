Voice.CustomerRoute = Ember.Route.extend({

  deactivate: ->
    @store.unloadAll('customer')
    @store.unloadAll('crmTicket')


  model: (params) ->
    @store.find('customer', params.customer_id)
})
