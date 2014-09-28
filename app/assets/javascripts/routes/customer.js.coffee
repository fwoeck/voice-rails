Voice.CustomerRoute = Ember.Route.extend({

  model: (params) ->
    @store.find('customer', params.customer_id)
})
