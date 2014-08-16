Voice.StatsRoute = Ember.Route.extend({

  model: ->
    Voice.set 'allDatasets', @store.all('dataset')
    @store.find('dataset')
})
