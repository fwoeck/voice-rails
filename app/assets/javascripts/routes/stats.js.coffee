Voice.StatsRoute = Ember.Route.extend({

  model: ->
    @controllerFor('datasets').set 'model', @store.all('dataset')
    @store.find('dataset')
})
