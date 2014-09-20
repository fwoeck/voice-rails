Voice.AgentsRoute = Ember.Route.extend({

  model: ->
    @store.all('user')


  activate: ->
    agent = Voice.store.createRecord(Voice.User)
    @controllerFor('agents').set('newAgent', agent)


  deactivate: ->
    @clearAgent()


  clearAgent: ->
    agent = @controllerFor('agents').get 'newAgent'
    agent.remove() if agent?.get('isNew')
})
