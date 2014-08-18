Voice.AgentsRoute = Ember.Route.extend({

  model: ->
    @store.all('user')
})
