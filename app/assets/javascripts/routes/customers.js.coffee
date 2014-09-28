Voice.CustomersRoute = Ember.Route.extend({

  deactivate: ->
    @store.unloadAll('searchResult')


  activate: ->
    @controllerFor('search_results').set 'model', @store.all('searchResult')
})
