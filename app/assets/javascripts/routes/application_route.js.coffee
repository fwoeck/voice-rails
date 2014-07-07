Voice.ApplicationRoute = Ember.Route.extend({

  model: ->
    Voice.store = @store
    Voice.aR    = @router
    @store.find('user')


  activate: ->
    @controllerFor('users').set 'model', @store.all('user')

})
