Voice.AgentsRoute = Ember.Route.extend({

  model: ->
    @store.all('user')


  activate: ->
    @controllerFor('agents').set 'newAgent', Voice.store.createRecord(Voice.User)


  deactivate: ->
    @clearAgent()


  clearAgent: ->
    agent = @controllerFor('agents').get 'newAgent'
    agent.deleteRecord() if agent?.get('isNew')
})
