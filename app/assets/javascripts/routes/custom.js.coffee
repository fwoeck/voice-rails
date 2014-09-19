Voice.CustomRoute = Ember.Route.extend({

  activate: ->
    @store.unloadAll('searchResult')
    @controllerFor('search_results').set 'model', @store.all('searchResult')
})
