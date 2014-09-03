Voice.AgentController = Ember.ObjectController.extend({

  actions:
    callAgent: (agent) ->
      cu = Voice.get('currentUser')

      if cu != agent && cu.get('isCallable') && agent.get('isCallable')
        agent.call()
      false
})
