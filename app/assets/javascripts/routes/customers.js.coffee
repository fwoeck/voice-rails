Voice.CustomersRoute = Ember.Route.extend({

  deactivate: ->
    @store.unloadAll('searchResult')
    @controllerFor('customers').set 'openRequest', false


  activate: ->
    @controllerFor('search_results').set 'model', @store.all('searchResult')
})
