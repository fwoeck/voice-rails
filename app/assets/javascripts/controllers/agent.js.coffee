Voice.AgentController = Ember.ObjectController.extend({

  actions:
    callAction: (agent) ->
      cu      = Voice.get('currentUser')
      state   = agent.get('agentState')
      cuState = cu.get('agentState')

      if cu != agent && state == cuState == 'registered'
        agent.call()
      false
})
