Voice.AgentController = Ember.ObjectController.extend({

  actions:
    callAction: (agent) ->
      state   = agent.get('agentState')
      cu      = Voice.get('currentUser')
      cuState = cu.get('agentState')

      @handleCallAction(agent, state, cu, cuState)
      false


  handleCallAction: (agent, state, cu, cuState) ->
    if state == cuState == 'talking'
      @hangupCall()
    else if cu != agent && state == cuState == 'registered'
      @call(agent)


  hangupCall: ->
    app.dialog(
      'Do you want to hangup your current call?', 'question'
    ).then ( ->
      Voice.get('currentCall')?.hangup()
    ), (->)


  call: (agent) ->
    app.dialog(
      "Do you want to call<br /><strong>#{agent.get 'displayName'} / #{agent.get 'name'}</strong>?", 'question'
    ).then ( ->
      agent.call()
    ), (->)

})
