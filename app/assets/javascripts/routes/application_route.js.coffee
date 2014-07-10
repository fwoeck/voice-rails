Voice.ApplicationRoute = Ember.Route.extend({

  model: ->
    Voice.store = @store
    Voice.aR    = @router

    Ember.RSVP.all([
      @store.find('call'),
      @store.find('user')
    ])


  activate: ->
    @controllerFor('calls').set 'model', @store.all('call')
    @controllerFor('users').set 'model', @store.all('user')

    Voice.set 'allCalls',    @store.all('call')
    Voice.set 'allUsers',    @store.all('user')
    Voice.set 'currentUser', @store.getById('user', env.userId)

})
