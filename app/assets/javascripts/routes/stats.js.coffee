Voice.StatsRoute = Ember.Route.extend({

  model: ->
    @store.find('dataset')


  activate: ->
    Voice.set 'allDatasets', @store.all('dataset')

    @refreshTimer = window.setInterval (->
      Voice.store.find('dataset')
    ), 3000


  deactivate: ->
    window.clearInterval @refreshTimer
})
